module ExceptionHelper
  extend ActiveSupport::Concern

  included do
    # ToDo Narrow down the catching of exceptions. and make different cases;
    rescue_from Exception, with: :error_render_method

    private
    def error_render_method(e)
      log_and_send_exception_mail(e)
      render json: { success: false, status_code: 201, message: e.message }
    end

    def log_and_send_exception_mail(e)
      logger.error e
      logger.error e.backtrace
      browser_data = Util.detect_browser(request.env['HTTP_USER_AGENT'])
      data = {
          params: params.as_json,
          browser: browser_data,
          browser_version: browser_data[1],
          user_agent: request.env['HTTP_USER_AGENT'],
          referer: request.referer,
          time: DateTime.current,
          host: Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
      }

      # ExceptionNotifier.notify_exception(e, data: data, exception_recipients: GlobalConstant::DEVS)
    end
  end

end