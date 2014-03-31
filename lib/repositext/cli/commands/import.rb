class Repositext
  class Cli
    module Import

    private

      # Import from all sources and merge into /content
      def import_all(options)
        reset_validation_report_once(options, 'rt import all')
        import_docx_specific_steps(options)
        import_folio_xml_specific_steps(options)
        import_idml_specific_steps(options)
        import_shared_steps(options)
      end

      # Import DOCX and merge into /content
      def import_docx(options)
        reset_validation_report_once(options, 'rt import docx')
        import_docx_specific_steps(options)
        import_shared_steps(options)
      end

      # Import FOLIO XML and merge into /content
      def import_folio_xml(options)
        reset_validation_report_once(options, 'rt import folio_xml')
        import_folio_xml_specific_steps(options)
        import_shared_steps(options)
      end

      # Import IDML and merge into /content
      def import_idml(options)
        reset_validation_report_once(options, 'rt import idml')
        import_idml_specific_steps(options)
        import_shared_steps(options)
      end

      def import_test(options)
        # dummy method for testing
        puts 'import_test'
      end

      # -----------------------------------------------------
      # Helper methods for DRY process specs
      # -----------------------------------------------------

      def import_docx_specific_steps(options)
        # convert_docx_to_???(options)
        # validate_utf8_encoding(options.merge(input: 'import_docx_dir/repositext_files'))
      end

      def import_folio_xml_specific_steps(options)
        report_file_spec = config.compute_glob_pattern(
          options['report_file'] || 'import_folio_xml_dir/validation_report_file'
        )
        validate_folio_xml_import({
          'run_options' => %w[pre_import],
          'report_file' => report_file_spec
        }.merge(options))
        convert_folio_xml_to_at(options)
        fix_remove_underscores_inside_folio_paragraph_numbers(options)
        fix_convert_folio_typographical_chars(options)
        validate_folio_xml_import({
          'run_options' => %w[post_import],
          'report_file' => report_file_spec
        }.merge(options))
      end

      def import_idml_specific_steps(options)
        report_file_spec = config.compute_glob_pattern(
          options['report_file'] || 'import_idml_dir/validation_report_file'
        )
        validate_idml_import({
          'run_options' => %w[pre_import],
          'report_file' => report_file_spec
        }.merge(options))
        convert_idml_to_at(options)
        validate_idml_import({
          'run_options' => %w[post_import],
          'report_file' => report_file_spec
        }.merge(options))
      end

      # Specifies all shared steps that need to run after each import
      def import_shared_steps(options)
        # TODO: this would be a lot more efficient if we processed only files
        # that have actually changed.
        merge_record_marks_from_folio_xml_at_into_idml_at(options)
        fix_adjust_merged_record_mark_positions(options)
        fix_convert_abbreviations_to_lower_case(options) # run after merge_record_marks...
        move_staging_to_content(options)
        validate_content(
          {
            'report_file' => config.compute_glob_pattern(
              options['report_file'] || 'content_dir/validation_report_file'
            )
          }.merge(options)
        )
      end

    end
  end
end
