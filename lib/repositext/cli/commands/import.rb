class Repositext
  class Cli
    module Import

    private

      # Import from all sources and merge into /content
      def import_all(options)
        import_docx_specific_steps(options)
        import_folio_xml_specific_steps(options)
        import_idml_specific_steps(options)
        import_shared_steps(options)
      end

      # Import DOCX and merge into /content
      def import_docx(options)
        import_docx_specific_steps(options)
        import_shared_steps(options)
      end

      # Import FOLIO XML and merge into /content
      def import_folio_xml(options)
        import_folio_xml_specific_steps(options)
        import_shared_steps(options)
      end

      # Import IDML and merge into /content
      def import_idml(options)
        import_idml_specific_steps(options)
        import_shared_steps(options)
      end

      def import_test(options)
        # dummy method for testing
        puts 'import_test'
      end

      # Helper methods for DRY process specs

      def import_docx_specific_steps(options)
        # convert_docx_to_???(options)
        # validate_utf8_encoding(options.merge(input: 'import_docx_dir/repositext_files'))
      end

      def import_folio_xml_specific_steps(options)
        validate_folio_xml_import({ 'run_validations' => %w[pre_import] }.merge(options))
        convert_folio_xml_to_at(options)
        fix_convert_folio_typographical_chars(options)
        validate_folio_xml_import(
          {
            'run_validations' => %w[post_import],
            'report_file' => config.compute_glob_pattern(
              options['report_file'] || 'import_folio_xml_dir/validation_report_file'
            )
          }.merge(options)
        )
      end

      def import_idml_specific_steps(options)
        convert_idml_to_at(options)
        validate_utf8_encoding(options.merge('input' => 'import_idml_dir/repositext_files'))
      end

      # Specifies all shared steps that need to run after each import
      def import_shared_steps(options)
        # TODO: this would be a lot more efficient if we processed only files
        # that have actually changed.
        merge_record_marks_from_folio_xml_at_into_idml_at(options)
        fix_adjust_merged_record_mark_positions(options)
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
