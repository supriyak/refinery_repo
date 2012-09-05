module Refinery
  module Inquiries
    class InquiryMailer < ActionMailer::Base

      def confirmation(inquiry, request)
        @inquiry = inquiry
        mail :subject   => Refinery::Inquiries::Setting.confirmation_subject(Globalize.locale),
             :to        => inquiry.email,
             :from      => Refinery::Inquiries::Setting.from_email,
             :reply_to  => Refinery::Inquiries::Setting.notification_recipients.split(',').first,
             :content_type => "text/html"
      end

      def notification(inquiry, request)
        @inquiry = inquiry
        mail :subject => Refinery::Inquiries::Setting.notification_subject,
             :to      => Refinery::Inquiries::Setting.notification_recipients,
             :from    => Refinery::Inquiries::Setting.from_email,
             :content_type => "text/html"
      end

    end
  end
end
