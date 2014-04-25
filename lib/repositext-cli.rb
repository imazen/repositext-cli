require 'outcome'
require 'thor'

require 'repositext-kramdown'
require 'repositext-validation'
require 'suspension'

# Establish namespace and class inheritance before we require nested classes
# Otherwise we get a subclass mismatch error because Cli is initialized as
# standalone class (not inheriting from Thor)
class Repositext
  class Cli < Thor
  end
end

require 'repositext/cli/config'
require 'repositext/cli/long_descriptions_for_commands'
require 'repositext/cli/patch_thor_with_rtfile'
require 'repositext/cli/rtfile_dsl'
require 'repositext/cli/utils'

require 'repositext/cli/commands/compare'
require 'repositext/cli/commands/convert'
require 'repositext/cli/commands/fix'
require 'repositext/cli/commands/init'
require 'repositext/cli/commands/merge'
require 'repositext/cli/commands/move'
require 'repositext/cli/commands/report'
require 'repositext/cli/commands/sync'
require 'repositext/cli/commands/validate'

require 'repositext/cli/commands/export'
require 'repositext/cli/commands/import'

require 'repositext/cli'
