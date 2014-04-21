require 'net/ftp'
module RedHatSupportLib
  module Network
    class FtpConnection
      def initialize(host)
        @host = host
      end

      def upload(file_name, remote_directory)
        Net::FTP.open(@host) do |ftp|
          ftp.login
          files = ftp.chdir(remote_directory)
          ftp.putbinaryfile(file_name)
        end
      end

    end
  end
end
