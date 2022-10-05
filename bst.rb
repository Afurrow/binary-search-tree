class Node
    attr_accessor :left, :right, :data

    def initialize(data)
        @data = data 
        @left = nil
        @right = nil
    end 
end


class Tree
    attr_accessor :root, :data

    def initialize(arr)
        @data = arr.uniq.sort
        @root = build_tree(data)
    end

    def build_tree(arr)     
        return nil if arr.empty?

        middle = arr.size / 2
        root_node = Node.new(arr[middle])

        root_node.left = build_tree(arr[0...middle])
        root_node.right = build_tree(arr[(middle + 1)..-1])
        
        root_node
    end 

    def pretty_print(node=@root, prefix='', is_left=true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def insert(val, node=@root) 
        return nil if val == node.data

        if val < node.data
            node.left.nil? ? node.left = Node.new(val) : insert(val, node.left)
        else 
            node.right.nil? ? node.right = Node.new(val) : insert(val, node.right)
        end         
    end 

    def delete(val, node=@root)
        return node if node.nil?

        if val < node.data 
            node.left = delete(val, node.left)
        elsif val > node.data 
            node.right = delete(val, node.right)
        else 
            return node.right if node.left.nil? 
            return node.left if node.right.nil?

            left = node.left 
            lcount = 1
            while not left.left.nil? 
                lcount += 1
                left = left.left
            end 

            right = node.right 
            rcount = 1
            while not right.left.nil?
                rcount += 1
                right = right.left
            end 

            if lcount > rcount 
                delete(left.data)
                node.data = left.data
            else
                delete(right.data) 
                node.data = right.data  
            end 
        end 
        node 
    end 

    def find(val, node=@root)
        return node if node.nil? || node.data == val 

        val < node.data ? find(val, node.left) : find(val, node.right)
    end 

    def level_order(node = root, queue = [])
        return nil if node.nil? 

        output = [] 
        queue.push(node) 
        until queue.empty? 
            cur = queue.shift
            output.push(block_given? ? yield(cur) : cur.data)
            queue.push(cur.left) if cur.left 
            queue.push(cur.right) if cur.right 
        end 
        output
    end

    def in_order(node=@root, output=[], &block)
        return nil if node.nil? 

        in_order(node.left, output, &block)
        output.push(block_given? ? block.call(node) : node.data)
        in_order(node.right, output, &block)

        output
    end 

    def pre_order(node=@root, output=[], &block)
        return nil if node.nil?

        output.push(block_given? ? block.call(node) : node.data)
        pre_order(node.left, output, &block)
        pre_order(node.right, output, &block)
    
        output
    end 
    
    def post_order(node=@root, output=[], &block)
        return nil if node.nil?

        post_order(node.left, output, &block)
        post_order(node.right, output, &block)
        output.push(block_given? ? block.call(node) : node.data)
    
        output
    end 

    def height(node = root)
        unless node.nil? || node == root
            node = (node.instance_of?(Node) ? find(node.data) : find(node))
        end
    
        return -1 if node.nil?
    
        [height(node.left), height(node.right)].max + 1
    end

    def depth(node)
        return nil if node.nil? 

        curr = @root 
        count = 0 
        until curr.data == node.data 
            count += 1
            curr = curr.left if node.data < curr.data 
            curr = curr.right if node.data > curr.data
        end 

        count       
    end 

    def balanced?(node = root)
        return true if node.nil?
    
        left_height = height(node.left)
        right_height = height(node.right)
    
        return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    
        false
    end

    def rebalance() 
        vals = in_order()
        @root = build_tree(vals)
    end
end  

arr = Array.new(15) { rand(0..100) }
bst = Tree.new(arr)
puts bst.balanced? 
print("#{bst.level_order()}\n")
print("#{bst.pre_order()}\n")
print("#{bst.post_order()}\n")
print("#{bst.in_order()}\n")
rand(100..200).times { bst.insert(rand(0..100)) }
puts bst.balanced? 
bst.rebalance()
puts bst.balanced? 
print("#{bst.level_order()}\n")
print("#{bst.pre_order()}\n")
print("#{bst.post_order()}\n")
print("#{bst.in_order()}\n")