require '/home/michael/odin_project/merge_sort/merge_sort.rb'

class Node
  include Comparable
  attr_accessor :value, :left, :right
  def initialize(value, left = nil, right = nil)
  @value = value
  @left = left
  @right = right
  end

  def <=>(other)
    self.value <=> other
  end
  
end

class NilClass
  def value
    return 0
  end
end
  
class Tree
  attr_accessor :value, :root
  
   
  def initialize(array)
    @value = array
    @root = build_tree
  end

  
  def build_tree(array = merge_sort(self.value.uniq), start = 0, final = array.length - 1 )
    return nil if start > final  #                            2
    mid = (start + final) / 2     # 1                       /   \
    root = Node.new(array[mid]) #                          1     3
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, final)
    return root   
  end

    
  def insert(number)
    #insert number as leaf at end of tree. iterate through the tree
    #if number is less than the node value it goes to the left. If it's greater it
    #goes to the right. stop when the next value of the node is nil.
    node = @root
    return "This number is already in the tree" if find_true?(number)
    while node.value
    if number > node.value
      if node.right.nil?
        node.right = Node.new(number)
        return node
      elsif node = node.right
      end
    end
    if number < node.value
      if node.left.nil?
        node.left = Node.new(number)
        return node
      elsif node = node.left
      end
    end
  end
           
  end

  def one_child?(node)
    if (node.left.nil? && node.right.nil? == false) || (node.right.nil? && node.left.nil? == false)
      return true
    else false
    end
  end

  def no_children?(node)
    if node.left.nil? && node.right.nil?
      return true
    else false
    end
  end

  def two_children?(node)
    if node.left.nil? == false && node.right.nil? == false
      return true
    else false
    end 
  end
  

  def find_parent(node = @root, number)
    #will find the parent node of a child I want to delete
    temp = @root
    return temp if temp.value == number 
    return node if node.left.nil? && node.right.nil?
    return node if node.left.value == number || node.right.value == number
      
    if number < node.value
      node = node.left
    else node = node.right
    end
    find_parent(node, number)
  end

  def find_one_child(node)
    parent = find(node)
    if parent.right == nil
      return parent.left
    end
    if parent.left == nil
      return parent.right
    end
  end

  def find_successor(node)
    current_node = find(node)
    next_node = current_node.right
    while next_node
      return next_node if next_node.left == nil
      next_node = next_node.left
    end
    #if next_node.left == nil 
     # return next_node
    #end
    #while next_node
      
    #else return next_node.left
    #end
  end
  def delete(number)
    #if node doesn't have children, make the value nil 
    node = find(number)
    if no_children?(node)
    parent = find_parent(number)
      if parent.left.value == number
        parent.left = nil
      end
      if parent.right.value == number
        parent.right = nil
      end
    end

    if one_child?(node)
      parent = find_parent(number)
      child = find(number)
      one_child = find_one_child(child)
      if one_child.value > parent.value
        parent.right = one_child
      end
      if one_child.value < parent.value
        parent.left = one_child
      end    
    end

    if two_children?(node)
    #start at finding the node
      successor = find_successor(node)
      if no_children?(successor)
        successor_parent = find_parent(successor)
                
         successor_parent.right = nil if successor_parent.right == successor
         successor_parent.left = nil if successor_parent.left == successor
         node.value = successor.value
      end
      if one_child?(successor)
        successor_parent = find_parent(successor)
        
        successor_parent.left = successor.right if successor_parent.value > successor.value
        successor_parent.right = successor.right if successor_parent.value < successor.value
        node.value = successor.value
      end
    end
    
  end
  def find_true?(value)
    if find(value) == "This number is not in the binary search tree"
      return false
    else true
    end
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def find(value)
    #returns node with given value
    node = @root
    return node if node.value == value
    while node.value
      if value > node.value
        if node.right.nil?
          return "This number is not in the binary search tree"
    
        end
        if node.right == value
          node = node.right
          return node
        elsif node = node.right
        end
      end
      if value < node.value
        if node.left.nil?
          return "This number is not in the binary search tree"
           
        end
        if node.left == value
          node = node.left
          return node
        elsif node = node.left
        end
      end
    end
   
  end

  def level_order(current_node = @root, results = [], queue = [@root])
    #start at @root. put @root in queue []. Then, take value of @root
    #and put into a results array []. Then queue it's children and dequeue
    #it from the queue. If queue is empty we stop.
    
    return results if queue.empty?
     results << queue.first.value
     queue << current_node.left if current_node.left != nil
     queue << current_node.right if current_node.right != nil
    queue.delete(queue.first)
    current_node = queue.first
    
    level_order(current_node, results, queue)
    
  end

  def level_order_iteration
    current_node = @root
    results = []
    queue = [@root]

    while !queue.empty?
      results << queue.first.value
      queue << current_node.left if current_node.left != nil
      queue << current_node.right if current_node.right != nil
      queue.delete(queue.first)
      current_node = queue.first
    end
    return results
  end

  def preorder(node = @root, results = [])
    #returns array of values
    return results if node == nil
    results << node.value
    preorder(node.left, results)
    preorder(node.right, results)
  end

  def inorder(node = @root, results = [])
    return results if node == nil
    inorder(node.left, results)
    results << node.value
    inorder(node.right, results)

  end
  def postorder(node = @root, results = [])
    return results if node == nil
    postorder(node.left, results)
    postorder(node.right, results)
    results << node.value
  end

  def balanced_height(node)
    new_arr = inorder(find(node))
    height = Math.log2(new_arr.length).floor
    return height
  end

  def height(node)
     node_one = find(node)
     node_two = find(node)
     #return 0 if no_children?(node)
     left_count = 0
     right_count = 0
     
     while node_one.left
      left_count += 1
      node_one = node_one.left
    end
    
    while node_two.right
      right_count += 1
      node_two = node_two.right
    end
    
    if left_count > right_count
      return left_count
    else right_count
    end
    
  end

  def depth(node)
    counter = 0 
    node = find(node)
    while node != @root
      node = find_parent(node)
      counter += 1
    end
    return counter
  end

  def balanced?
   node_one = @root
   node_two = @root
   left_count = 0
   right_count = 0

   while node_one.left
   left_count += 1
   node_one = node_one.left
   end
   while node_two.right
     right_count += 1
     node_two = node_two.right
   end
   if left_count > right_count
     greater = left_count
   else greater = right_count
   end
   if left_count < right_count
     lesser = left_count
   else lesser = right_count
   end

   if greater - lesser > 1
     return false
   else true
   end
  end

  def rebalance
    arr = inorder
    balanced = build_tree(arr)
    @root = balanced
  end

end

random = Tree.new(Array.new(15) { rand(1..100) })
#random.pretty_print
p random.balanced?
p random.level_order
p random.preorder
p random.inorder
p random.postorder
random.insert(142)
random.insert(146)
random.insert(148)
random.insert(152)
random.insert(167)
p random.balanced?
random.rebalance
p random.balanced?
p random.level_order
p random.preorder
p random.inorder
p random.postorder









 







 














