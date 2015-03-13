require 'avl_tree'
require 'forwardable'
require 'delegate'


class IntervalTree::Enode

  def self.new(nodeclass)
    enode = AVLTree::Node::EMPTY.dup
    enode.instance_variable_set(:@nodeclass, nodeclass)

    def enode.nodeclass
      @nodeclass
    end

    def enode.insert(key, val)
      @nodeclass.new(key)
    end
    enode
  end

  def max_endpoint
    nil
  end


  def set_max_endpoints
    nil
  end
end


# We need a minimal wrapper around our keys (range-like objects)
# do deal with how AVLTree is implemented, since we need a good
# <=>. Use delegator to get that.

class IntervalTree::KeyWrapper < Delegator
  def initialize(v)
    @value = v
  end

  def __getobj__
    @value
  end


  # We define <=> based solely on key.begin. Since we're not protecting
  # against duplication (identical intervals may have different
  # metadata), never return 0 (equality); only 1 or -1
  def <=>(other)
    return -1 if other.nil?
    if self.begin <=> other.begin < 1
      -1
    else
      1
    end
  end

end



class IntervalTree::Node < AVLTree::Node


  attr_reader :max_endpoint

  # delegate begin, end, and cover to the key
  extend Forwardable
  def_delegators :@key, :begin, :end, :'cover?'


  # Get an empty node
  EMPTY_NODE = IntervalTree::Enode.new(self).freeze

  def self.empty_node
    EMPTY_NODE
  end

  def set_max_endpoints
    if self.empty?
      @max_endpoint = nil
    else
      @max_endpoint = [key.end, @left.set_max_endpoints, @right.set_max_endpoints].compact.max
    end
    @max_endpoint
  end



  # Change initialize to use our own empty class
  def initialize(key)
    super(IntervalTree::KeyWrapper.new(key), nil)
    @left    = @right = self.class.empty_node
    @max_endpoint = nil
  end


end
