require 'avl_tree'
class IntervalTree < AVLTree
end
require "interval_tree/version"
require 'interval_tree/node'
require 'interval_tree/empty_node'



# An interval tree is one where (a) the nodes have begin/endpoints, and
# (b) you can efficiently determine which nodes "cover" a given value --
# those within whose limits the key falls.
#
# An interval tree is a special case of a binary tree. In this case,
# I'm basing the implementation off of nahi's AVLTree.
#
# One issue is that the underlying code (and, in fact, all the implementations
# I've seen) don't allow injection of the base node or empty node types.
# We'll fix that in our subclass.



class IntervalTree < AVLTree

  def initialize(default = DEFAULT, nodeclass= IntervalTree::Node, &block)
    super(default, &block)
    @nodeclass = nodeclass
    self.clear
  end

  def empty?
    @root.empty?
  end

  def clear
    @root = @nodeclass.empty_node
  end


  def insert(key)
    super(IntervalTree::KeyWrapper.new(key),nil)
  end

  def [](key)
    "Need to implement this"
  end

  def set_max_endpoints
    @root.set_max_endpoints
    self
  end

  def rotate
    super
    set_max_endpoints
  end


end



