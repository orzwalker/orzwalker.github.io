---
title: LRU
date: 2021-04-05 20:56:51
tags:
- LRU
- LinkedHashMap
categories:
- 算法
---

> Leetcode 146	

```java
class LRUCache {

    /* 手动实现双向链表和基本方法 */
    private Map<Integer, Node> map;
    private DoubleEndList doubleEndList;
    private int MAX_CAPACITY;

    public LRUCache(int capacity) {
        this.map = new HashMap<>();
        this.doubleEndList = new DoubleEndList();
        this.MAX_CAPACITY = capacity;
    }


    public int get(int key) {
        if (!map.containsKey(key)) {
            return -1;
        }
        Node node = map.get(key);
        doubleEndList.remove(node);
        doubleEndList.addLast(node);
        return node.val;
    }

    public void put(int key, int val) {
        Node node = new Node(key, val);
        if (map.containsKey(key)) {
            doubleEndList.remove(map.get(key));
            doubleEndList.addLast(node);
            map.put(key, node);
        } else {
            if (MAX_CAPACITY == doubleEndList.size()) {
                // 淘汰
                Node deleteNode = doubleEndList.removeFirst();
                map.remove(deleteNode.key);
            }
            doubleEndList.addLast(node);
            map.put(key, node);
        }
    }



    /**
     * 双向链表结点
     */
    class Node {
        int key, val;
        Node prev, next; // 前后指针

        public Node(int key, int val) {
            this.key = key;
            this.val = val;
        }
    }

    /**
     * 双向链表
     * <p>
     * 表尾表示最近使用的
     * 表头表示最久未使用的，从头部开始淘汰
     */
    class DoubleEndList {
        private Node head, tail; // 头尾虚结点
        private int size; // 链表长度

        public DoubleEndList() {
            head = new Node(0, 0);
            tail = new Node(0, 0);
            head.next = tail;
            tail.prev = head;
            size = 0;
        }

        /**
         * 尾部插入，最近使用的在尾部
         *
         * @param node
         */
        public void addLast(Node node) {
            // 注意顺序，否则指针指向会有问题
            node.next = tail;
            node.prev = tail.prev;
            tail.prev.next = node;
            tail.prev = node;
            size++;
        }

        /**
         * 删除双向链表中的某个结点
         *
         * @param node
         */
        public void remove(Node node) {
            node.prev.next = node.next;
            node.next.prev = node.prev;
            size--;
        }

        /**
         * 删除链表头部结点，LRU中淘汰链表的头部结点
         *
         * @return 头结点，删除hash表中的key使用
         */
        public Node removeFirst() {
            if (head.next == tail) {
                return null;
            }
            Node first = head.next;
            remove(first);
            return first;
        }

        /**
         * 链表size
         *
         * @return int
         */
        public int size() {
            return size;
        }
    }
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache obj = new LRUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
```

