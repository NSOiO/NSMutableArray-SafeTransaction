# NSMutableArray-SafeTransaction
NSMutableArray thread safe transaction

NSMutableArray is not thread safe,envn if you add lock to every API.

Supposed this:

- 1. Thread #1 get the count of the mutable array.
- 2. Thread #2 remove the last objct.
- 3. Thread #1 access the count-1 object,then throw exception.
