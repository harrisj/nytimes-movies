# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nytimes-movies}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Harris"]
  s.date = %q{2009-02-12}
  s.description = %q{A gem for talking to the New York Times Movie Reviews API}
  s.email = %q{jharris@nytimes.com}
  s.files = ["History.txt", "Rakefile", "README.rdoc", "VERSION.yml", "lib/nytimes", "lib/nytimes/movies", "lib/nytimes/movies/base.rb", "lib/nytimes/movies/critic.rb", "lib/nytimes/movies/link.rb", "lib/nytimes/movies/multimedia_link.rb", "lib/nytimes/movies/result_set.rb", "lib/nytimes/movies/review.rb", "lib/nytimes/movies.rb", "lib/nytimes-movies.rb", "test/nytimes", "test/nytimes/movies", "test/nytimes/movies/test_critic.rb", "test/nytimes/movies/test_link.rb", "test/nytimes/movies/test_multimedia_link.rb", "test/nytimes/movies/test_result_set.rb", "test/nytimes/movies/test_review.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/harrisj/nytimes-moves}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A gem for talking to the New York Times Movie Reviews API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end
