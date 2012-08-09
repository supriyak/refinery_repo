class TransferredDataController < ApplicationController
  #skip_before_filter :check_if_mobile?,:only=>[:mobile_thanks_submit]
  # GET /transferred_data
  # GET /transferred_data.json
  def lifescript_form
    @userinfo =  Userinfo.new()
    @userinfo.firstname = params[:firstname] if params[:firstname]
    @userinfo.lastname  = params[:lastname] if params[:lastname]
    @userinfo.email     = params[:email] if params[:email]
    @userinfo.address1  = params[:address] if params[:address]
    @userinfo.city      = params[:city] if params[:city]
    @userinfo.state     = params[:state] if params[:state]
    @userinfo.zip       = params[:zip] if params[:zip]
    @userinfo.partner   = "Lifescript"
    @userinfo.source_tracking3   = params[:utm_source] || "lifescript"
    @userinfo.url   =  request.referer
    @userinfo.ip_address = request.env['REMOTE_ADDR']
    @userinfo.vid = cookies[:hlprx_visit_id]
    @userinfo.printing_type = 'registration'
    @userinfo.save
    matchtype = session[:matchtype]
    adid      = session[:adid]
    term      = session[:utm_term]
    browser   = get_browser(request.env['HTTP_USER_AGENT'].downcase)
    os        = get_operating_system(request.env['HTTP_USER_AGENT'].downcase)
    device    = get_device(request.env['HTTP_USER_AGENT'].downcase)
    cookies[:hlprx_visit_id] = {:value => @userinfo.id, :expires => Time.now + 1.days}  if cookies[:hlprx_visit_id].blank?
    source_tracking3 = cookies[:hlprx_utm_source]
    source,sourcekey = generate_source(source_tracking3)
    options = {:lifescript => "lifescript",:browser=>browser,:os=>os,:device=>device,:ip=>request.env['REMOTE_ADDR'],:matchtype => matchtype,:adid => adid,:matchterm => term,:id=>@userinfo.id,:source=>source,:sourcekey=>sourcekey,:sourcetracking1 => @userinfo.source_tracking1,:sourcetracking2 => @userinfo.source_tracking2 }
    response = get_coupon_value(options)
    api_response = {}##get_contact(response["Contacts"]) if response && !response["Contacts"].blank?
    cookies[:hlprx_prospect_id] = {:value => api_response["ProspectId"], :expires => Time.now + 30.days} if api_response && api_response["ProspectId"]
    @userinfo.update_attributes(:network => cookies[:hlprx_network], :browser => browser, :os => os, :device => device, :matchtype => matchtype, :adid => adid,
                                :matchterm => term, :api_response => (!response["Errors"].blank?||response["HasWarnings"]) ? (response["Errors"].join(',')+response["Warnings"].join(',')) : nil,
                                :api_success => response["Success"], :partner => source_tracking3, :source => source, :bin => api_response["BIN"], :grpcode => api_response["GroupNumber"],
                                :member_number => api_response["MemberNumber"], :pcn => api_response["PCN"], :prospectid => cookies[:hlprx_prospect_id])
    
    render :template=>'/transferred_data/lifescript_form',:layout=> false
  end

  def show
    @userinfo = Userinfo.find(params[:id])
    @g = params[:g] if params[:g]
    code = "HNA"
    @bin =     @userinfo.bin || $BIN
    @pcn  =     @userinfo.pcn || $PCN
    @usernumber = @userinfo.member_number || code + @userinfo.id.to_s.rjust(6,"0")
    @groupno = @userinfo.grpcode || $GRP
    respond_to do |format|
      format.html
    end
  end

  # GET /transferred_data/new
  # GET /transferred_data/new.json
  def new
    if params[:layout]
      @source = "helpgoog2"
      layout = "application_new_nav"
    else
      layout = "application"
    end
    @source = params[:source] if @source.blank? && !params[:source].blank? 
	  @page_title='Free Card - HelpRx.info'
    session[:sign_up] = "yes"
    if (session[:sales_tag_added].nil?)
       session[:sales_tag_added] = true
       @sales_tag = true
    else
      @sales_tag = false
    end
      
    @transferred_datum = TransferredDatum.new
    @transferred_datum.email = params[:email] if params[:email]
    @m = params[:m] if params[:m]
    @path = request.path
    render :layout => layout    
  end

  def new_lightbox
    if params[:layout]
      layout = "application_new_nav"
    else
      layout = "application"
    end
	  @page_title='Free Card - HelpRx.info'
    session[:sign_up] = "yes"
    if (session[:sales_tag_added].nil?)
       session[:sales_tag_added] = true
       @sales_tag = true
    else
      @sales_tag = false
    end

    @transferred_datum = TransferredDatum.new
    @transferred_datum.email = params[:email] if params[:email]
    @m = params[:m] if params[:m]
    @path = request.path    
    render :template=>'/transferred_data/new_nav/', :layout => false    
  end

  def thanks_submit
    @userinfo = Userinfo.find(params[:id])
    @g = params[:g] if params[:g]
    code = "HNA"
    @bin =     @userinfo.bin || $BIN
    @pcn  =     @userinfo.pcn || $PCN
    @usernumber = @userinfo.member_number || code + @userinfo.id.to_s.rjust(6,"0")
    @groupno = @userinfo.grpcode || $GRP
    render :template=>'transferred_data/thanks_submit/', :layout => false
  end

  def fmly_thanks_submit
    @userinfo = Userinfo.find(params[:id])
    @g = params[:g] if params[:g]
    code = "HNA"
    @bin =     @userinfo.bin || $BIN
    @pcn  =     @userinfo.pcn || $PCN
    @usernumber = @userinfo.member_number || code + @userinfo.id.to_s.rjust(6,"0")
    @groupno = @userinfo.grpcode || $GRP
    render :template=>'transferred_data/fmly_thanks_submit/', :layout => false
  end

  def alt_sign_up
    @transferred_datum = TransferredDatum.new
    @m = params[:m] if params[:m]
    @path = request.path
    render :template=>'transferred_data/alt_sign_up',:layout=>false
  end

  # POST /transferred_data
  # POST /transferred_data.json
  def create
      coupon = Coupon.find_by_name(params[:transferred_datum][:current_prescription])
      userinfo = Userinfo.create(:firstname => params[:transferred_datum][:firstname],:lastname => params[:transferred_datum][:lastname],:email => params[:transferred_datum][:email],
          :address1=> params[:transferred_datum][:address1],:address2 => params[:transferred_datum][:address2],:city => params[:transferred_datum][:city],:state => params[:transferred_datum][:state],
          :zip => params[:transferred_datum][:zip],:pcn => params[:transferred_datum][:pcn],:bin => params[:transferred_datum][:bin],:url => params[:transferred_datum][:url],
          :ip_address => params[:transferred_datum][:remote_ip],:rx => params[:transferred_datum][:current_prescription],:grpcode => params[:transferred_datum][:groupno],
          :source_tracking3 => params[:transferred_datum][:partner], :discounts => (coupon.savings if !coupon.blank?),:prescription_id => (coupon.id if !coupon.blank?),
          :path=>params[:transferred_datum][:path], :vid => cookies[:hlprx_visit_id], :subsource => params[:transferred_datum][:subsource], :creative => params[:transferred_datum][:creative],
          :printing_type => "registration",:userid => session[:uid])
   
    cookies[:hlprx_visit_id] = {:value => userinfo.id, :expires => Time.now + 1.days}  if cookies[:hlprx_visit_id].blank?
    respond_to do |format|
      if userinfo
        m = params[:m] ? params[:m] : params[:transferred_datum][:current_prescription]
        source_tracking3 = cookies[:hlprx_utm_source]
        if (!params[:source].blank?)
          source = params[:source]
          sourcekey = "hlpdgd"
        else
          source,sourcekey = generate_source(source_tracking3)  
        end
        
        matchtype  = session[:matchtype]
        adid       = session[:adid]
        term       = session[:utm_term]
        browser    = get_browser(request.env['HTTP_USER_AGENT'].downcase)
        os         = get_operating_system(request.env['HTTP_USER_AGENT'].downcase)
        device     = get_device(request.env['HTTP_USER_AGENT'].downcase)
        is_email  = (params[:new_nev] == "email_new_nev") ? true : false
        is_sms    = (params[:new_nev] == "sms_new_nev") ? true : false
        if !coupon.blank?
         name      = coupon.name
         savings   = coupon.savings.to_f
        end
        options    = {:coupon=>name,:savings=>savings,:browser=>browser,:os=>os,:device=>device,:ip=>request.env['REMOTE_ADDR'],:matchtype => matchtype,:adid => adid,:matchterm => term,:id=>userinfo.id, :creative => params[:transferred_datum][:creative], :subsource => params[:transferred_datum][:subsource], :prescription=>m,:source=>source,:sourcekey=>sourcekey,:sourcetracking1 => userinfo.source_tracking1,:sourcetracking2 => userinfo.source_tracking2,:email_coupon_address=>is_email,:sms_coupon_address=>is_sms}
        response = get_coupon_value(options)
        api_response = get_contact(response["Contacts"]) if response && response["Contacts"]
        cookies[:hlprx_prospect_id] = {:value => api_response["ProspectId"], :expires => Time.now + 30.days} if api_response && api_response["ProspectId"]
        userinfo.update_attributes(:network=>cookies[:hlprx_network],:browser=>browser,:os=>os,:device=>device,:matchtype => matchtype,:adid => adid,:matchterm => term,:api_response=>(!response["Errors"].blank?||response["HasWarnings"]) ? (response["Errors"].join(',')+response["Warnings"].join(',')) : nil,:api_success =>response["Success"] ,:partner=>source_tracking3,:source=>source ,:bin =>api_response["BIN"],:grpcode =>api_response["GroupNumber"],:member_number => api_response["MemberNumber"],:pcn => api_response["PCN"],:prospectid => cookies[:hlprx_prospect_id] )
        if params[:new_nev] == "email_new_nev"
          format.html { redirect_to email_thanks_submit_path(:id => userinfo.id)}
        elsif params[:new_nev] == "sms_new_nev"
          format.html { redirect_to sms_thanks_submit_path(:id => userinfo.id)}
        else  
          format.html { redirect_to "/transferred_data/#{userinfo.id}"}
        end
        
      elsif params["alt-sign-up"] == "alt-sign-up"
        format.html { render :action => "alt_sign_up",:layout=>false  }
      else
        format.html { render :action => "new"  }
      end
    end
  end

  def thankyou_invite_friends
    user = Userinfo.find(params[:id])
    Emailer.send_card_to_friends(params,user).deliver
  end




  def email_sent_to_family
   if params[:transferred_datum1] || params[:transferred_datum2]
       sender = Userinfo.find(params[:id])
       @userinfo1 = Userinfo.create(:firstname => params[:transferred_datum1][:firstname],:lastname => params[:transferred_datum1][:lastname],
                    :email => params[:transferred_datum1][:email],:address1=> params[:transferred_datum1][:address1],
                    :address2 => params[:transferred_datum1][:address2],:city => params[:transferred_datum1][:city],
                    :state => params[:transferred_datum1][:state],:zip => params[:transferred_datum1][:zip],
                    :source => params[:transferred_datum1][:source_id],
                    :grpcode => params[:transferred_datum1][:groupno],:partner => params[:transferred_datum1][:partner],
                    :url => params[:transferred_datum1][:url],:path => params[:transferred_datum1][:path],
                    :subsource => params[:transferred_datum1][:subsource],:creative => params[:transferred_datum1][:creative],
                    :ip_address => params[:transferred_datum1][:remote_ip],:rx => params[:transferred_datum1][:rx],
                    :vid => cookies[:hlprx_visit_id],:userid => session[:uid],:printing_type => "friends"
                  ) if params[:transferred_datum1]

       @userinfo2 = Userinfo.create(:firstname => params[:transferred_datum2][:firstname],:lastname => params[:transferred_datum2][:lastname],
                    :email => params[:transferred_datum2][:email],:address1=> params[:transferred_datum2][:address1],
                    :address2 => params[:transferred_datum2][:address2],:city => params[:transferred_datum2][:city],
                    :state => params[:transferred_datum2][:state],:zip => params[:transferred_datum2][:zip],
                    :source => params[:transferred_datum2][:source_id],
                    :grpcode => params[:transferred_datum2][:groupno],:partner => params[:transferred_datum2][:partner],
                    :url => params[:transferred_datum2][:url],:path => params[:transferred_datum2][:path],
                    :subsource => params[:transferred_datum2][:subsource],:creative => params[:transferred_datum2][:creative],
                    :ip_address => params[:transferred_datum2][:remote_ip],:rx => params[:transferred_datum2][:rx],
                    :vid => cookies[:hlprx_visit_id],:userid => session[:uid],:printing_type => "friends"
                  ) if params[:transferred_datum2]
       @userinfo1 = fmly_call_api(@userinfo1)
       @userinfo2 = fmly_call_api(@userinfo2)
       respond_to do |format|
         format.html {render :layout => false}
       end
   else
     respond_to do |format|
         format.html {render :layout => false}
       end
   end
  end


  def invite_friends
    @sender  = Userinfo.find(params[:id])
  end

  def send_card_to_family
    @transferred_datum1 = TransferredDatum.new
    @transferred_datum2 = TransferredDatum.new
    @userinfo = Userinfo.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def cloudsponge_send_to_phone
  end

  def download_mobile_card
    send_file "#{Rails.root.to_s}/public/#{params[:image_path]}.png"
  end

  def re_mob
    options = {:id => nil, :source => "HelpReMob", :sourcekey => "hlpdgd", :subsource => cookies[:hlprx_utm_subsource], :creative => cookies[:hlprx_utm_creative]}
   @image_path = "ReMobCard.png"
   @add_tag = true
   full_result = get_coupon_value(options)
   @result     = full_result["Contacts"].last
   cookies[:hlprx_prospect_id] = {:value => @result["ProspectId"], :expires => Time.now + 30.days}
    Userinfo.create(:api_response=>(!full_result["Errors"].blank?||full_result["HasWarnings"]) ? (full_result["Errors"].join(',')+full_result["Warnings"].join(',')) : nil,:api_success =>full_result["Success"] ,
      :bin =>@result["BIN"],:grpcode =>@result["GroupNumber"],:member_number => @result["MemberNumber"],
      :pcn => @result["PCN"], "url"=>request.referer,"ip_address"=>request.env['REMOTE_ADDR'] , :subsource => cookies[:hlprx_utm_subsource], :creative => cookies[:hlprx_utm_creative],:prospectid => cookies[:hlprx_prospect_id])
    respond_to do |format|
      format.html {render :template => "transferred_data/mobile_thanks_submit", :layout=> false}
    end
  end

  def mobile_thanks_submit
    options = {:id => nil, :source => "helpmob", :sourcekey => "hlpdgd", :subsource => cookies[:hlprx_utm_subsource], :creative => cookies[:hlprx_utm_creative]}
    @image_path = "MobCard.png"
    full_result = get_coupon_value(options)
    @result     = full_result["Contacts"].last
    cookies[:hlprx_prospect_id] = {:value => @result["ProspectId"], :expires => Time.now + 30.days}
    Userinfo.create(:api_response=>(!full_result["Errors"].blank?||full_result["HasWarnings"]) ? (full_result["Errors"].join(',')+full_result["Warnings"].join(',')) : nil,:api_success =>full_result["Success"] ,
      :bin =>@result["BIN"],:grpcode =>@result["GroupNumber"],:member_number => @result["MemberNumber"],
      :pcn => @result["PCN"], "url"=>request.referer,"ip_address"=>request.env['REMOTE_ADDR'], :subsource => cookies[:hlprx_utm_subsource] , :creative => cookies[:hlprx_utm_creative],:prospectid => cookies[:hlprx_prospect_id])
    respond_to do |format|
      format.html {render :layout=> false}
    end
  end
  
end
