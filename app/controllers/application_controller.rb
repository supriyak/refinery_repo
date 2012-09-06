class ApplicationController < ActionController::Base
  require 'open-uri'
  require 'json'
  require 'net/http'
  require 'net/https'
  require "uri"
  protect_from_forgery
  def default_source
    SourcePairing.find_by_source("helporganic")
  end
  def deafult_api_values
    prefix     = "HNA" #If there are timeouts and you have to default to something"
    usernumber = Userinfo.maximum('id') + 1
    {"BIN"=>$BIN, "PCN"=>$PCN, "GroupNumber"=>$GRP, "MemberNumber"=>prefix+usernumber.to_s.rjust(6,"0")}
  end
  def get_device(agent)
  mobile_browsers = ["android", "ipod", "ipad", "iphone", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
      device = ""
      mobile_browsers.each do |m|
        if agent.include?(m)
           device = m
           return device
        end
      end
    device
  end
  def get_contact(contacts)
    return nil if contacts.blank?
    for contact in contacts
      if (contact["ContactTypeId"] == 1 || contact["ContactTypeId"] == 2 )
        return contact
      end
      return contacts.first
    end
  end
  def generate_source(utm_source = nil, network = nil)
    utm_source = utm_source || cookies[:hlprx_utm_source]
    network = network || cookies[:hlprx_network]
    if network.blank?
      source_obj = SourcePairing.find_by_utm_source(utm_source)
    else
      source_obj  = SourcePairing.first(:conditions=>["utm_source LIKE ? and network = ?",('%'+utm_source.to_s),network])
    end
    if source_obj.blank?
      source_obj = default_source
    end

    source = source_obj.source
    sourcekey = source_obj.source_key
    return source=source,sourcekey=sourcekey
  end
  def get_browser(user_agent)
    if user_agent.index('opera')
       return 'opera'
    elsif user_agent.index('konqueror')
       return 'konqueror'
    elsif user_agent.index('chrome/')
       return 'chrome'
    elsif user_agent.index('applewebkit/')
       return 'safari'
    elsif user_agent.index('googlebot/')
       return 'googlebot'
    elsif user_agent.index('msnbot')
       return 'msnbot'
    elsif user_agent.index('yahoo! slurp')
      return 'yahoobot'
    #Everything thinks it's mozilla, so this goes last
    elsif user_agent.index('firefox')
       return 'firefox'
    elsif user_agent.index('msie')
       return 'internet explorer'
    else
       return 'unknown'
    end
  end
  def get_operating_system(req)
  if req.downcase.match(/mac/i)
    return "Mac"
  elsif req.downcase.match(/windows/i)
    return "Windows"
  elsif req.downcase.match(/linux/i)
    return "Linux"
  elsif req.downcase.match(/unix/i)
    return "Unix"
  else
    return "Unknown"
  end
end
def check_if_bot?
    agent = request.user_agent.downcase if request.user_agent
    if agent
      $BOT_AGENTS.each do |ba|
        if agent.match(ba)
          @bot_request = true
        end
      end
    end
  end

 def get_coupon_value(options)
    result = {}
    if (@bot_request && @bot_request == true)
      return {"BIN"=>$BIN, "PCN"=>$PCN, "GroupNumber"=>$GRP, "MemberNumber"=>$BOT_UID}
    end
    begin
      Timeout.timeout(7.to_i) do
        if Rails.cache.read(:failures).to_i <= $deafult_api_failure_count
          user = Userinfo.find_by_id(options[:id])
          #values of call_api(options,User,ContactTypeId,email_contact_type_id,sms_contact_type_id)
          if !user.blank?
            if options[:lifescript] == "lifescript"
              c_id = 22
            elsif options[:lifescript_print] == "lifescript_print"
              c_id = 2
              options[:send_coupon_email] = true
              options[:send_coupon_sms] = true
              e_id = 13
              @is_lifescript =true
            else
            	c_id = 1
              e_id = 3
              @is_email = true
            end
            result = call_api(options,user,c_id,e_id,0)
          elsif options[:send_coupon_email] && options[:email].blank?
            options[:send_coupon_email] = false
            result = call_api(options,nil,3)
          elsif options[:send_coupon_sms] && options[:phone_number].blank?
            options[:send_coupon_sms] = false
            result = call_api(options,nil,5)
          elsif options[:send_coupon_email] && !options[:email].blank?
            @is_email = true
            result = call_api(options,nil,0,13)
          elsif options[:send_coupon_sms] && !options[:phone_number].blank?
            @is_sms = true
            result = call_api(options,nil,5,nil,14)
          elsif !options[:source].blank? && !options[:sourcekey].blank?
            result = call_api(options,nil,2,0,0)
          end
         p result
         p 'result'
        end
      end

    rescue Timeout::Error => e
      @msg = e.message
      no_of_failure = Rails.cache.read(:failures) || 0
      Rails.cache.write(:failures,no_of_failure+1,:expires_in => 1.minute)
      Rails.logger.error("Http request timeout ")
    end
      msg = @msg.blank? ? "API response is blank and we are using default api values" : "Timeout Error" + ":"+ @msg
      result = {"Errors"=>[msg],"HasWarnings"=>false,"Warnings"=>[],"Success"=>false,"Contacts"=>[deafult_api_values]} if result.blank?
      errors = (!result.blank? && !result["Errors"].blank?) ? result["Errors"] : []
      result = {"Errors"=>errors,"HasWarnings"=>false,"Warnings"=>[],"Success"=>(result["Success"] || false),"Contacts"=>[deafult_api_values]} if !result.blank? && result["Contacts"].blank?
    return result
  end

  def call_api(options,user=nil,contact_type_id=1,email_contact_type_id=3,sms_contact_type_id=5)
   url = URI.parse($api_url)
      request = Net::HTTP::Post.new(url.path, initheader = {'Content-Type' =>'application/json','Accept' => 'application/json'})
      first_name = user.nil? ? "" : user.firstname
      last_name  = user.nil? ? "" : user.lastname
      address1   = user.nil? ? "" : user.address1
      address2   = user.nil? ? "" : user.address2
      email      = user.nil? ? "" : user.email
      city       = user.nil? ? "" : user.city
      state      = user.nil? ? "" : user.state
      zip        = user.nil? ? "" : user.zip
      savings    = options[:savings].blank? ? 0 : options[:savings]/100
      prospect_id =  cookies[:hlprx_prospect_id].blank? || options[:lifescript] ? 0 :  cookies[:hlprx_prospect_id]
      partner    = cookies[:rxreliefcard_partner].blank? ? "default" : cookies[:rxreliefcard_partner]
      #api_credential = Refinery::ApiCredentials::ApiCredential.find_by_partner(partner)
      #if !api_credential.blank?
       #username  = api_credential.username
       #password  = api_credential.password
      #else
       username  = $PartnerUsername
       password  = $PartnerPassword
      #end
      s= {
        "PartnerUsername"=>username,
        "PartnerPassword"=>password,
        "SendEmail"=>options[:send_coupon_email] || @is_email || false,
        "SendSMS"=>options[:send_coupon_sms] || false,
        "ProspectValues"=>{
                "ProspectId"=>prospect_id,
                "ProspectType"=>1,
                "FirstName"=>first_name,
                "LastName"=> last_name,
                "Address1"=>address1 || "",
                "Address2"=>address2 || "",
                "City"=>city,
                "State"=>state,
                "PostalCode"=>zip,
                "Email"=>(!email.blank? ? email : options[:email]) || "",
                "Phone"=>options[:phone_number] || ""
        },
   "ContactValues"=>{
                "ContactTypeId"=>contact_type_id,
                "Prescription"=>options[:coupon] || "",
		"SavingsPercent"=>savings,
                "Creative"=>options[:creative] || "",
                "Subsource"=>options[:subsource] || "",
                "UTMCampaign"=>cookies[:hlprx_utm_campaign] || "",
                "UTMMedium"=>cookies[:hlprx_utm_medium] || "",
                "UTMSource"=>cookies[:hlprx_utm_source] || ""
        },
   "ContactTrackingData"=>{
                "matchtype"=>options[:matchtype] || "",
                "matchterm"=>options[:matchterm] || "",
                "searchstring"=>options[:searchstring] || "",
                "adid"=>options[:adid] || "",
                "network"=>cookies[:hlprx_network] || "",
                "ip"=>options[:ip] || "",
                "device"=>options[:device] || "",
                "browser"=>options[:browser] || "",
                "os"=>options[:os] || ""
        }
       }
       type_ids_hash = {:EmailContactTypeId=>email_contact_type_id} if @is_email && !email_contact_type_id.blank?
       type_ids_hash = {:EmailContactTypeId=>email_contact_type_id} if @is_lifescript && !email_contact_type_id.blank?
       type_ids_hash = {:SMSContactTypeId=>sms_contact_type_id} if @is_sms  &&  !sms_contact_type_id.blank?
       s.merge!(type_ids_hash)if !type_ids_hash.blank?
       p s.to_json
       request.body = s.to_json
       http = Net::HTTP.new(url.host, url.port)
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       response = http.start {|http|
                http.request(request)
                }
       p response
       result =  JSON.parse(response.body)
       p "result"
       p result
       return result
  end
end
