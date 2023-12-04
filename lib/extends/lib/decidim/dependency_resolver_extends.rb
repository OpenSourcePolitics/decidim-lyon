# frozen_string_literal: true

# Backport from https://github.com/decidim/decidim/pull/12061/files
# Related to : https://github.com/decidim/decidim/issues/11636
module DependencyResolverExtends
  # Finds a gem specification from the locked gems of the instance.
  #
  # Note that this does not resolve if the module is needed or not. This may
  # also return the gem specification even when it is not listed in the
  # Gemfile, e.g. when the Decidim gems are installed through git.
  #
  # @param name [String] The name of the gem to find.
  # @return [Bundler::LazySpecification, nil] The specification for the gem
  #   or nil if the gem is not listed in the locked gems.
  def spec(name)
    sp = Bundler.definition.locked_gems.specs.find { |s| s.name == name }

    # Fetching the gem through Gem.loaded_specs ensures we are not returning
    # a lazy specification which does not respond to `#full_gem_path` which
    # is needed for the resolver.
    return Gem.loaded_specs[sp.name] if sp

    nil
  end
end

Decidim::DependencyResolver::Lookup.class_eval do
  prepend(DependencyResolverExtends)
end
