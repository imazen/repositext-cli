class Repositext
  class Cli
    module Validate

    private

      # Validates that all files in file set have valid AT syntax
      def validate_at_syntax(options)
        input_file_spec = options[:input] || 'import_folio_xml_dir/at_files'
        vfs = config.compute_validation_file_specs(primary: input_file_spec)
        Repositext::Validation.new('AtFiles', vfs, options).run
      end

      # Validates all files related to folio xml import
      def validate_folio_xml_import(options)
        vfs = config.compute_validation_file_specs(
          folio_xml_sources: options[:input] || 'import_folio_xml_dir/xml_files',
          imported_at_files: 'import_folio_xml_dir/at_files',
          imported_repositext_files: 'import_folio_xml_dir/repositext_files',
        )
        Repositext::Validation.new('Utf8Encoding', vfs, options).run
        Repositext::Validation.new(
          'AtFiles',
          config.compute_validation_file_specs(primary: 'import_folio_xml_dir/at_files'),
          options
        ).run
      end

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
