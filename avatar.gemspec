# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{avatar}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Rosen"]
  s.date = %q{2009-07-16}
  s.description = %q{Adds support for rendering avatars from a variety of sources.}
  s.email = %q{james.a.rosen@gmail.com}
  s.files = ["History.txt", "License.txt", "README.rdoc", "init.rb", "rails/init.rb", "lib/avatar", "lib/avatar/object_support.rb", "lib/avatar/source", "lib/avatar/source/abstract_source.rb", "lib/avatar/source/file_column_source.rb", "lib/avatar/source/gravatar_source.rb", "lib/avatar/source/nil_source.rb", "lib/avatar/source/paperclip_source.rb", "lib/avatar/source/pavatar_source.rb", "lib/avatar/source/source_chain.rb", "lib/avatar/source/static_url_source.rb", "lib/avatar/source/wrapper", "lib/avatar/source/wrapper/abstract_source_wrapper.rb", "lib/avatar/source/wrapper/rails_asset_source_wrapper.rb", "lib/avatar/source/wrapper/string_substitution_source_wrapper.rb", "lib/avatar/source/wrapper.rb", "lib/avatar/source.rb", "lib/avatar/version.rb", "lib/avatar/view", "lib/avatar/view/abstract_view_support.rb", "lib/avatar/view/action_view_support.rb", "lib/avatar/view.rb", "lib/avatar.rb"]
  s.homepage = %q{http://github.com/gcnovus/avatar}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Grammar RDoc", "--charset", "utf-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Multi-source avatar support}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
