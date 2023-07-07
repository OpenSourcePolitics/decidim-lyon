# frozen_string_literal: true

module DecidimApp
  module K8s
    module SecondaryHostsChecker
      def self.valid_secondary_hosts(host:, secondary_hosts:)
        secondary_hosts.select do |secondary_host|
          valid_secondary_host?(host, secondary_host)
        end
      end

      def self.valid_secondary_host?(host, secondary_host)
        return true if host == secondary_host

        host == get_redirection_target(secondary_host)
      end

      def self.get_redirection_target(host, limit = 3)
<<<<<<< HEAD
        return nil if limit.zero? # Avoid infinite loops
        return nil unless host.is_a?(URI) || host.is_a?(String)

        url = URI(host)
        host = (url.host || url.path)
        req = Net::HTTP::Get.new("/")
        response = Net::HTTP.start(host, 80) { |http| http.request(req) }
=======
        raise "Secondary host #{host} is not valid because of too many redirections" if limit.zero?

        req = Net::HTTP::Get.new("/")
        response = Net::HTTP.start(host, 443, use_ssl: true) { |http| http.request(req) }
>>>>>>> fdbb062 (K8S - Check if secondary hosts are valid (#350))

        case response
        when Net::HTTPSuccess
          host
        when Net::HTTPRedirection
          get_redirection_target(response["location"], limit - 1)
        end
<<<<<<< HEAD
      rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
=======
      rescue SocketError, Errno::ECONNREFUSED
>>>>>>> fdbb062 (K8S - Check if secondary hosts are valid (#350))
        nil
      end
    end
  end
end
