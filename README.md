# magpie - ECS package project in Swift

magpie is a personal project where i try to implement a **lightweight ECS package** aimed as a backend for any game logic and renderer of your choice.

## Package
#### World
*top level container*
#### EntityAllocator and Entities
*entities with generation*
#### ComponentStore and Components
*type erased generic stores with sparse sets*

ComponentsStores uses ContiguousArrays to keep the data compact. Since swift boxes values greater than 3 words, it is not feasable to have ComponentStore<Component> implementation. So stores have generic methods where we downcast them to concrete implementations during compiletime. So users can register desired components which conform to the Component protocol.

Components are equatable and hashable.
#### CommandBuffer and Commands
*delayed store commands to prevent array resizing during iteration*

#### Queries
*parameter pack iteration(Swift 6.0+) *
#### System Scheduler

>[!CAUTION]
> not implemented

#### EventBus and Events
*message queue for system communication*
>[!CAUTION]
> not implemented

#### Pseudorandom Number Generator (SplitMix64)
*fast prng for seeding*

#### Vector and Matrix Ops
*for storing and transforming component data*



