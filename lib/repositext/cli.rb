class Repositext
  class Cli < Thor

    class RtfileError < RuntimeError; end

    FILE_SPEC_DELIMITER = '/'

    include Thor::Actions
    include Cli::RtfileDsl
    include Cli::LongDescriptionsForCommands

    include Cli::Compare
    include Cli::Convert
    include Cli::Fix
    include Cli::Init
    include Cli::Merge
    include Cli::Move
    include Cli::Report
    include Cli::Sync
    include Cli::Validate

    include Cli::Export
    include Cli::Import

    # For rtfile template loading
    def self.source_root
      File.dirname(__FILE__)
    end

    class_option :rtfile,
                 :type => :string,
                 :required => true,
                 :desc => 'Specifies which Rtfile to use. Defaults to the closest Rtfile found in the directory hierarchy.'
    class_option :input,
                 :type => :string,
                 :desc => 'Specifies the input file pattern. Expects an absolute path pattern that can be used with Dir.glob.'
    class_option :changed_only,
                 :type => :boolean,
                 :default => true,
                 :desc => 'If true, only files that have been changed or added will be processed.'

    # Override original initialize so that the options hash is not frozen. We
    # need to modify it.
    def initialize(args=[], options={}, config={})
      super
      @options = @options.dup
    end


    # Basic commands


    desc "compare SPEC", "Compares files for consistency"
    long_desc long_description_for_compare
    # @param[String] command_spec Specification of the operation
    def compare(command_spec)
      self.send("compare_#{ command_spec }", options)
    end


    desc 'convert SPEC', 'Converts files from one format to another'
    long_desc long_description_for_convert
    # @param[String] command_spec Specification of the operation
    def convert(command_spec)
      self.send("convert_#{ command_spec }", options)
    end


    desc 'fix SPEC', 'Modifies files in place'
    long_desc long_description_for_fix
    # @param[String] command_spec Specification of the operation
    def fix(command_spec)
      self.send("fix_#{ command_spec }", options)
    end


    desc "init", "Generates a default Rtfile"
    long_desc long_description_for_init
    method_option :force,
                  :aliases => "-f",
                  :desc => "Flag to force overwriting an existing Rtfile"
    # TODO: allow specification of Rtfile path
    # @param[String, optional] command_spec Specification of the operation. This
    #     is used for testing (pass 'test' as command_spec)
    def init(command_spec = nil)
      if command_spec
        self.send("init_#{ command_spec }", options)
      else
        generate_rtfile(options)
      end
    end


    desc 'merge SPEC', 'Merges the contents of two files'
    long_desc long_description_for_merge
    method_option :input_1,
                  :type => :string,
                  :desc => 'Specifies the input file pattern for the first file. Expects an absolute path pattern that can be used with Dir.glob.'
    method_option :input_2,
                  :type => :string,
                  :desc => 'Specifies the base directory for the second file. Expects an absolute path to a directory.'
    # @param[String] command_spec Specification of the operation
    def merge(command_spec)
      self.send("merge_#{ command_spec }", options)
    end


    desc 'move SPEC', 'Moves files to another location'
    long_desc long_description_for_move
    # @param[String] command_spec Specification of the operation
    def move(command_spec)
      self.send("move_#{ command_spec }", options)
    end


    desc 'report SPEC', 'Generates a report'
    long_desc long_description_for_report
    # @param[String] command_spec Specification of the operation
    def report(command_spec)
      self.send("report_#{ command_spec }", options)
    end


    desc 'sync SPEC', 'Syncs data between different file types in /content'
    long_desc long_description_for_sync
    # @param[String] command_spec Specification of the operation
    def sync(command_spec)
      self.send("sync_#{ command_spec }", options)
    end

    desc 'validate SPEC', 'Validates files'
    long_desc long_description_for_validate
    method_option :report_file,
                  :type => :string,
                  :default => nil,
                  :desc => 'Specifies a file name to which a validation report will be written.'
    method_option :run_options,
                  :type => :array,
                  :default => %w[pre_import post_import],
                  :desc => 'Specifies which validations to run. Possible values: %w[pre_import post_import]'
    # @param[String] command_spec Specification of the operation
    # NOTE: --input option can only use named file_specs, not dir.glob patterns.
    def validate(command_spec)
      if options['report_file']
        new_options = options.dup # Thor options are a frozen Hash
        new_options['report_file'] = config.compute_glob_pattern(options['report_file'])
      else
        new_options = options
      end
      self.send("validate_#{ command_spec }", new_options)
    end


    # Higher level commands


    desc 'export SPEC', 'Exports files from /content'
    long_desc long_description_for_export
    # @param[String] command_spec Specification of the operation
    def export(command_spec)
      self.send("export_#{ command_spec }", options)
    end

    desc 'import SPEC', 'Imports files and merges changes into /content'
    long_desc long_description_for_import
    # @param[String] command_spec Specification of the operation
    def import(command_spec)
      self.send("import_#{ command_spec }", options)
    end

  private

    def config
      @config ||= Cli::Config.new
    end
    # This writer is used for testing to inject a mock config
    def config=(a_config)
      @config = a_config
    end

  end
end
