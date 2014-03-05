class Repositext
  class Cli
    module Validate

    private

      # Validates that all files in file set are UTF8 encoded
      def validate_utf8_encoding(options)
        input_file_spec = options[:input] || 'rtfile_dir/repositext_files'
        vfs = config.compute_validation_file_specs(primary: input_file_spec)
        Repositext::Validation.new('Utf8Encoding', vfs, options).run
      end

      def validate_test(options)
        # dummy method for testing
        puts 'validate_test'
      end

    end
  end
end
