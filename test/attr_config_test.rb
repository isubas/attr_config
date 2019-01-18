require 'test_helper'

class AttrConfigTest < Minitest::Test
  class Base
    include AttrConfig::Configurable

    attr_config :bar, default: 'Base#bar'
    attr_config :foo
    attr_config :only_instance_readable,
                default: 'Base#only_instance_readable',
                readable: { class: false }
    attr_config :only_class_readable,
                default: 'Base#only_class_readable',
                readable: { instance: false }
    attr_config :only_instance_writable,
                default: 'Base#only_instance_writable',
                writable: { class: false }
    attr_config :only_class_writable,
                default: 'Base#only_class_writable',
                writable: { instance: false }
    attr_config :only_access_via_config,
                default: 'Base#only_access_via_config',
                readable: { instance: false, class: false },
                writable: { instance: false, class: false }
  end

  class Sample < Base
    include AttrConfig::Configurable

    attr_config :bar, default: 'Sample#bar'
    attr_config :foo, default: 'Sample#foo'
    attr_config :test, default: 'Sample#test'
  end

  BASE_CONFIGS = %i[
    bar
    foo
    only_instance_readable
    only_class_readable
    only_instance_writable
    only_class_writable
    only_access_via_config
  ].freeze

  def test_configs_must_be_defined_for_base_class
    assert_equal Base.attr_configs.keys, BASE_CONFIGS
  end

  def test_configs_must_be_defined_for_base_sample
    configs = BASE_CONFIGS.dup << :test
    assert_equal Sample.attr_configs.keys, configs
  end

  def test_default_value_can_be_assigned
    assert_nil Base.foo
    assert_equal Base.bar, 'Base#bar'
    assert_equal Sample.bar, 'Sample#bar'
    assert_equal Sample.test, 'Sample#test'
  end

  def test_config_options_can_be_overridden_in_subclass
    assert Base.attr_configs[:bar] != Sample.attr_configs[:bar]
    assert_equal Base.attr_configs[:only_access_via_config],
                 Sample.attr_configs[:only_access_via_config]
  end

  def test_only_instance_readable_for_base_class
    instance = Base.new

    assert_equal instance.only_instance_readable, 'Base#only_instance_readable'
    assert_raises(NoMethodError) { Base.only_instance_readable }
  end

  def test_only_instance_readable_for_sample_class
    instance = Sample.new

    assert_equal instance.only_instance_readable, 'Base#only_instance_readable'
    assert_raises(NoMethodError) { Sample.only_instance_readable }
  end

  def test_only_class_readable_for_base_class
    instance = Base.new

    assert_equal Base.only_class_readable, 'Base#only_class_readable'
    assert_raises(NoMethodError) { instance.only_class_readable }
  end

  def test_only_class_readable_for_sample_class
    instance = Base.new

    assert_equal Base.only_class_readable, 'Base#only_class_readable'
    assert_raises(NoMethodError) { instance.only_class_readable }
  end

  def test_only_instance_writable_for_base_class
    instance = Base.new
    instance.only_instance_writable = 'Test'
    assert_equal instance.only_instance_writable, 'Test'
    assert_raises(NoMethodError) { Base.only_instance_writable = 'Test' }
  end

  def test_only_instance_writable_for_sample_class
    instance = Sample.new
    instance.only_instance_writable = 'Test'
    assert_equal instance.only_instance_writable, 'Test'
    assert_raises(NoMethodError) { Sample.only_instance_writable = 'Test' }
  end

  def test_only_class_writable_for_base_class
    instance = Base.new
    Base.only_class_writable = 'Test'
    assert_equal Base.only_class_writable, 'Test'
    assert_raises(NoMethodError) { instance.only_class_writable = 'Test' }
  end

  def test_only_class_writable_for_sample_class
    instance = Sample.new
    Sample.only_class_writable = 'Test'
    assert_equal Sample.only_class_writable, 'Test'
    assert_raises(NoMethodError) { instance.only_class_writable = 'Test' }
  end

  def test_only_access_via_config_for_base_class
    instance = Base.new

    assert_raises(NoMethodError) { Base.only_access_via_config }
    assert_raises(NoMethodError) { Base.only_access_via_config = 'Test' }
    assert_raises(NoMethodError) { instance.only_access_via_config }
    assert_raises(NoMethodError) { instance.only_access_via_config = 'Test' }

    assert_equal Base.config.only_access_via_config, 'Base#only_access_via_config'
    assert_equal instance.config.only_access_via_config, 'Base#only_access_via_config'

    Base.config.only_access_via_config = 'TestBaseClass'
    instance.config.only_access_via_config = 'TestBaseInstance'

    assert_equal Base.config.only_access_via_config, 'TestBaseClass'
    assert_equal instance.config.only_access_via_config, 'TestBaseInstance'
  end

  def test_only_access_via_config_for_sample_class
    instance = Sample.new

    assert_raises(NoMethodError) { Sample.only_access_via_config }
    assert_raises(NoMethodError) { Sample.only_access_via_config = 'Test' }
    assert_raises(NoMethodError) { instance.only_access_via_config }
    assert_raises(NoMethodError) { instance.only_access_via_config = 'Test' }

    assert_equal Sample.config.only_access_via_config, 'Base#only_access_via_config'
    assert_equal instance.config.only_access_via_config, 'Base#only_access_via_config'

    Sample.config.only_access_via_config = 'TestSampleClass'
    instance.config.only_access_via_config = 'TestSampleInstance'

    assert_equal Sample.config.only_access_via_config, 'TestSampleClass'
    assert_equal instance.config.only_access_via_config, 'TestSampleInstance'
  end

  def test_configuration_change_on_instance_should_not_affect_the_class
    base_instance = Base.new
    sample_instance = Sample.new

    base_instance.bar = 'BaseInstance#Bar'
    sample_instance.bar = 'SampleInstance#Bar'

    assert_equal base_instance.bar, 'BaseInstance#Bar'
    assert_equal sample_instance.bar, 'SampleInstance#Bar'
    assert_equal Base.bar, 'Base#bar'
    assert_equal Sample.bar, 'Sample#bar'
  end
end
