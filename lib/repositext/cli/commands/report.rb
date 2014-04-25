class Repositext
  class Cli
    module Report

    private

      # Generate summary of folio import warnings
      def report_folio_import_warnings(options)
        input_file_spec = options['input'] || 'import_folio_xml_dir/json_files'
        uniq_warnings = Hash.new(0)
        Repositext::Cli::Utils.read_files(
          config.compute_glob_pattern(input_file_spec),
          /\.folio.warnings\.json\Z/i,
          "Reading folio import warnings",
          options
        ) do |contents, filename|
          warnings = JSON.load(contents)
          warnings.each do |warning|
            message_stub = warning['message'].split(':').first || ''
            uniq_warnings[message_stub] += 1
          end
        end
        uniq_warnings.to_a.sort { |a,b| a.first <=> b.first }.each do |(message, count)|
          $stderr.puts " - #{ message }: #{ count }"
        end
      end

    end
  end
end
