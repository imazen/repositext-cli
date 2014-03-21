class Repositext
  class Cli
    module Validate

    private

      # Validates that all files in file set have valid AT syntax
      def validate_at_syntax(options)
        input_file_spec = options['input'] || 'import_folio_xml_dir/at_files'
        vfs = config.compute_validation_file_specs(primary: input_file_spec)
        Repositext::Validation.new('AtFiles', vfs, options).run
      end

      # Validates all files in /content
      def validate_content(options)
        file_specs = config.compute_validation_file_specs(
          at_files: 'content_dir/at_files',
          repositext_files: 'content_dir/repositext_files'
        )
        # Repositext::Validation.new(
        #   'Utf8Encoding',
        #   { :primary => file_specs[:repositext_files] },
        #   options
        # ).run
        Repositext::Validation.new(
          'AtFiles',
          { :primary => file_specs[:at_files] },
          options
        ).run
      end

      # Validates all files related to folio xml import
      def validate_folio_xml_import(options)
        file_specs = config.compute_validation_file_specs(
          folio_xml_sources: options['input'] || 'import_folio_xml_dir/xml_files',
          imported_at_files: 'import_folio_xml_dir/at_files',
          imported_repositext_files: 'import_folio_xml_dir/repositext_files',
        )

        if options['run_validations'].include?('pre_import')
          Repositext::Validation.new(
            'Utf8Encoding',
            { :primary => file_specs[:folio_xml_sources] },
            options
          ).run
        end

        if options['run_validations'].include?('post_import')
          Repositext::Validation.new(
            'Utf8Encoding',
            { :primary => file_specs[:imported_repositext_files] },
            options
          ).run
          Repositext::Validation.new(
            'AtFiles',
            { :primary => file_specs[:imported_at_files] },
            options
          ).run
        end
      end

      # Validates that all files in file set are UTF8 encoded
      def validate_utf8_encoding(options)
        input_file_spec = options['input'] || 'import_idml_dir/repositext_files'
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
