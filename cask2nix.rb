require 'json'
require 'global'
require 'hbc'

def cask(header_token, **options, &block)
  cask = Hbc::Cask.new(header_token, &block)
  puts JSON.generate({
                       :name => cask.name[0],
                       :version => cask.version,
                       :sha256 => cask.sha256,
                       :url => cask.url,
                       :homepage => cask.homepage,
                       :apps => cask.artifacts
                                  .select { |a| a.is_a?(Hbc::Artifact::App) }
                                  .map { |a| {
                                           :target => a.target,
                                           :source => a.source.basename
                                         } }
                     })
end

require ARGV[0]
