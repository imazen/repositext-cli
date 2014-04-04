class Repositext
  class Cli
    module Validate

    private

      # Validates all files in /content directory
      def validate_content(options)
        options = {
          'report_file' => 'content_dir/validation_report_file'
        }.merge(options)
        if options['report_file']
          options['report_file'] = config.compute_glob_pattern(options['report_file'])
        end
        reset_validation_report_once(options, 'rt validate content')
        file_specs = config.compute_validation_file_specs(
          primary: 'content_dir/all_files', # for reporting only
          at_files: 'content_dir/at_files',
          pt_files: 'content_dir/pt_files',
          repositext_files: 'content_dir/repositext_files'
        )
        Repositext::Validation::Content.new(
          file_specs,
          {
            'kramdown_validation_parser_class' => config.kramdown_parser(:kramdown_validation)
          }.merge(options)
        ).run
      end

      # Validates all files related to folio xml import
      def validate_folio_xml_import(options)
        options = {
          'report_file' => 'import_folio_xml_dir/validation_report_file'
        }.merge(options)
        if options['report_file']
          options['report_file'] = config.compute_glob_pattern(options['report_file'])
        end
        reset_validation_report_once(options, 'rt validate folio_xml_import')
        file_specs = config.compute_validation_file_specs(
          primary: 'import_folio_xml_dir/all_files', # for reporting only
          folio_xml_sources: options['input'] || 'import_folio_xml_dir/xml_files',
          imported_at_files: 'import_folio_xml_dir/at_files',
          imported_repositext_files: 'import_folio_xml_dir/repositext_files',
        )
        Repositext::Validation::FolioXmlImport.new(
          file_specs,
          {
            'import_parser_class' => config.kramdown_parser(:folio_xml),
            'kramdown_converter_method_name' => config.kramdown_converter_method(:to_at),
            'kramdown_parser_class' => config.kramdown_parser(:kramdown),
            'kramdown_validation_parser_class' => config.kramdown_parser(:kramdown_validation)
          }.merge(options)
        ).run
      end

      # Validates all files related to idml import
      def validate_idml_import(options)
        options = {
          'report_file' => 'import_idml_dir/validation_report_file'
        }.merge(options)
        if options['report_file']
          options['report_file'] = config.compute_glob_pattern(options['report_file'])
        end
        reset_validation_report_once(options, 'rt validate idml_import')
        file_specs = config.compute_validation_file_specs(
          primary: 'import_idml_dir/all_files', # for reporting only
          idml_sources: options['input'] || 'import_idml_dir/idml_files',
          imported_at_files: 'import_idml_dir/at_files',
          imported_repositext_files: 'import_idml_dir/repositext_files',
        )

        Repositext::Validation::IdmlImport.new(
          file_specs,
          {
            'idml_validation_parser_class' => config.kramdown_parser(:idml_validation),
            'import_parser_class' => config.kramdown_parser(:idml),
            'kramdown_converter_method_name' => config.kramdown_converter_method(:to_at),
            'kramdown_parser_class' => config.kramdown_parser(:kramdown),
            'kramdown_validation_parser_class' => config.kramdown_parser(:kramdown_validation),
          }.merge(options)
        ).run
      end

      # Used for automated testing
      def validate_test(options)
        puts 'validate_test'
      end

      # ----------------------------------------------------------
      # Helper methods
      # ----------------------------------------------------------

      # Resets the validation report located at options['report_file']
      # unless options['append_to_report'] is true. In that case it will
      # leave the report file alone and just append to it.
      # Also sets the 'append_to_report' option to true to prevent downstream
      # validations from resetting it again
      # Validations by default append to the report file so that results of
      # earlier validations are not overwritten by those of later ones.
      # We set it up this way so that e.g., the commands in import can reset
      # the report file and stop called validations from resetting it again.
      # @param[Hash] options, salient keys: 'report_file' and 'append_to_report'
      # @param[String] marker. An id line that will be added to the top of the
      #    report, along with a time stamp.
      def reset_validation_report_once(options, marker)
        return true  if options['append_to_report']
        if options['report_file']
          # reset report
          Repositext::Validation.reset_report(options['report_file'], marker)
          # prevent downstream validations to reset again
          options['append_to_report'] = true
        end
      end

    end
  end
end
