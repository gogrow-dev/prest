# frozen_string_literal: true

require_relative 'lib/prest/version'

Gem::Specification.new do |spec|
  spec.name = 'prest'
  spec.version = Prest::VERSION
  spec.authors = ['Juan Aparicio']
  spec.email = ['juan.aparicio@gogrow.dev']

  spec.summary = 'Programmatically communicate with external REST API the easy way.'
  spec.homepage = 'https://gogrow.dev'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gogrow-dev/prest'
  spec.metadata['changelog_uri'] = 'https://github.com/gogrow-dev/prest/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.20.0'
end
