# TODO release this as a plugin as it matures
module RequirementAuthorization
  METHOD_SUFIX = '_required'
  
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  class Requirement
    CONTROLLER_OPTIONS = [:only, :except, :if, :unless]

    def initialize(opts={},&block)
      yield self if block_given?
    end
    
    # A proc or method that must return a true for the requirement to be satisified
    def guard(proc=nil, &block)
      @guard = controller_filter_proc(proc, &block)
    end
    alias :guard_if :guard

    def guard_unless(proc=nil, &block)
      # Lazily invert the return of the controller proc.
      @guard = Proc.new{|c, args| not controller_filter_proc(proc, &block).call(c, *args)}
    end
    
    # This is the method that we'll call if the guard fails. The resolution should take the user
    # through a flow where they can satisify the requirements for the requirement and pass on through.
    def resolution(proc=nil, &block)
      @resolution = controller_filter_proc(proc, &block)
    end
    
    # Sets up the filter for the controller by wrapping this requirement up in a proc.
    def filter(controller, *args)
      args, controller_options = extract_filter_args!(args)
      controller.before_filter Proc.new{|c| self.call(c, *args)}, controller_options
    end
    
    # The gaurd, resolution process. This is where the magic happens.
    def call(controller_instance, *args)
      @resolution.call(controller_instance, *args) if @guard.call(controller_instance, *args)
    end
    
  protected
    # Packages up a proc or a block into something that a controller can deal with
    def controller_filter_proc(proc=nil, &block)
      if block_given? # Instance eval the block in the context of the controller
        Proc.new{|c, args| c.instance_eval(&block)}
      elsif proc.respond_to?(:call) # Just run the proc, easy!
        Proc.new{|c, args| proc.call(*args)}
      else # This could be a symbol or string, which we'll send to the controller to see if it exists
        # TODO make this arity dyanmic...
        # The arity check lets us call a method in a controller with or without arguments
        Proc.new{|c, args| c.method(proc).arity == 0 ? c.send(proc) : c.send(proc, *args)}
      end
    end

    def extract_filter_args!(args)
      # Gives us the last hash in an array of args (e.g. before_filter :act1, :act2, :only => [:fun])
      # would return {:only => [:fun]}
      options = args.last.is_a?(Hash) ? args.pop : {}
      # Collect all of the controller options and delete them out of the options hash
      controller_options = options.inject({}) do |memo, (option, value)|
        memo[option] = options.delete(option) if CONTROLLER_OPTIONS.include?(option)
        memo
      end
      # The remaining pairs in the options hash should be put back into the args array
      # unless the hash is empty. If we pushed an empty hash theres a chance we'd screw
      # up the arity of calling functions within the controllers.
      args.push options unless options.empty?
      [ args, controller_options ]
    end
  end
  
  module ClassMethods
    # Setups a hash table of requirements that may be used by class methods from
    # other sub-classed controllers
    def requirement(requirement, opts={}, &block)
      self.requirements.merge! requirement.to_s => Requirement.new(opts, &block)
      
      # Build out the class method for this requirement. This is primarly used towards the
      # top of a controller.
      self.class.class_eval %{
        def #{requirement}#{METHOD_SUFIX}(*args)
          requirements['#{requirement}'].filter(self, *args)
        end}
      
      # Build out the instance method so that this requirement can be called from other
      # instance methods. This proves to be insanely useful for composing requirements 
      # together or reusing them from other methods.
      self.class_eval %{
        def #{requirement}#{METHOD_SUFIX}(*args)
          self.class.send(:requirements)['#{requirement}'].call(self, *args)
        end}
    end
        
  protected
    def requirements
      @@requirements ||= {}
    end
  end
end