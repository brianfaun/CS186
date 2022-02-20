# Brian Faun Spring 2022 CS186 Project 2 - B+ Trees

**DataBox**
A data box can contain data of the following types: Boolean (1 byte), Int (4 bytes), Float (4 bytes), Long (8 bytes) and String(N) (N bytes). 

**RecordId**
A record in a table is uniquely identified by its page number (the number of the page on which it resides) and its entry number (the record's index on the page). These two numbers (pageNum, entryNum) comprise a RecordId. 

**BPlusTree.java** - This file contains the class that manages the structure of the B+ tree. Every B+ tree maps keys of a type DataBox (a single value or "cell" in a table) to values of type RecordId (identifiers for records on data pages). An example of inserting and a retrieving records using keys can be found in the comments at @BPlusTree.java#L130

**BPlusNode.java** - A B+ node represents a node in the B+ tree, and contains similar methods to BPlusTree such as get, put and delete. BPlusNode is an abstract class and is implemented as either a LeafNode or an InnerNode

**LeafNode.java** - A leaf node is a node with no descendants that contains pairs of keys and Record IDs that point to the relevant records in the table, as well a pointer to its right sibling. More details can be found @LeafNode.java#L15

**InnerNode.java** - An inner node is a node that stores keys and pointers (page numbers) to child nodes (which themselves may either be an inner node or a leaf node). More details can be found @InnerNode.java#L15

**BPlusTreeMetadata.java-** This file contains a class that stores useful information such as the order and height of the tree. 

Generally, B+ trees do support duplicate keys. However, my implementation of B+ trees does not support duplicate keys. It will throw an exception whenever a duplicate key is inserted.

My implementation of B+ trees assumes that inner nodes and leaf nodes can be serialized on a single page. Thus, the invariant that all non-root leaf nodes in a B+ tree of order d contain between d and 2d entries is broken. Note that actual B+ trees do rebalance after deletion, but there will be undefined behvior for rebalancing trees in this project for the sake of simplicity.
