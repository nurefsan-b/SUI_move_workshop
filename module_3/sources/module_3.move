module module_3::hero; 
    // ========= IMPORTS =========
    use std::string::String;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;
    
    // ========= STRUCTS =========
    public struct Hero has key, store {
        id: UID,
        name: String,
        image_url: String,
        power: u64,
    }

    public struct ListHero has key, store {
        // TODO: Add the fields for the ListHero
        id: UID, // 1. The id of the ListHero
        nft : Hero, // 2. The nft object
        price : u64, // 3. The price of the Hero
        seller : address, // 4. The seller of the Hero
    }

    public struct HeroMetadata has key, store {
        // TODO: Add the fields for the HeroMetadata
        id: UID,  // 1. The id of the HeroMetadata
        timestamp: u64,  // 2. The timestamp of the HeroMetadata
    }

    // ========= EVENTS =========

    public struct HeroListed has copy, drop {
        // TODO: Add the fields for the HeroListed
        id: ID, // 1. The id of the listing
        price: u64, // 2. The price of the Hero
        seller: address, // 3. The seller of the Hero
        timestamp: u64, // 4. The timestamp of the HeroListed
    }

    public struct HeroBought has copy, drop {
        // TODO: Add the fields for the HeroBought
        id: ID, // 1. The id of the listing
        price : u64, // 2. The price of the Hero
        buyer : address, // 3. The buyer of the Hero
        seller: address, // 4. The seller of the Hero
        timestamp : u64, // 5. The timestamp of the HeroBought
    }

    // ========= FUNCTIONS =========

    #[allow(lint(self_transfer))]
    public entry fun create_hero(name: String, image_url: String, power: u64,  ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name,
            image_url,
            power
        };

        let hero_metadata = HeroMetadata {
            id: object::new(ctx), // TODO: Create the HeroMetadata object,
            timestamp : ctx.epoch_timestamp_ms(), // TODO: Get the epoch timestamp ,
        };

        transfer::transfer(hero, ctx.sender());

        transfer::freeze_object(hero_metadata); // TODO: Freeze the HeroMetadata object
        
    }



    public entry fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
        // TODO: Define the ListHero object,
        let list_hero = ListHero {
            // TODO: Define the fields for the ListHero object
            id: object::new(ctx), // 1. Create the object id for the ListHero object
            // 2. The nft object
            nft,
            // 3. The price of the Hero
            price,
            // 4. The seller of the Hero (the sender)
            seller:ctx.sender(),
        };

        // TODO: Emit the HeroListed event
         event::emit(HeroListed{
            id: object::id(&list_hero),
            price: price,
            seller: ctx.sender(),
            timestamp: ctx.epoch_timestamp_ms(),
         });


        // TODO: Share the ListHero object 
        transfer::share_object(list_hero);
    }

    public entry fun buy_hero(list_hero: ListHero, coin: Coin<SUI>, ctx: &mut TxContext) {
        // TODO: Deconstruct the ListHero object
        let ListHero { id ,nft ,price ,seller } =list_hero;
        // TODO: Assert the price of the Hero is equal to the coin amount
        assert!(coin::value(&coin) == price, 1);
        // TODO: Transfer the coin to the seller
        transfer::public_transfer(coin,seller);
        // TODO: Transfer the Hero object to the sender
        transfer::public_transfer(nft,ctx.sender());
        // TODO: Emit the HeroBought event
        event::emit(HeroBought{
            id: id.to_inner(),
            price: price,
            buyer: ctx.sender(),
            seller: seller,
            timestamp: ctx.epoch_timestamp_ms(),
        });
        // TODO: Destroy the ListHero object
        id.delete();
    }

    public entry fun transfer_hero(hero: Hero, to: address) {
        transfer::public_transfer(hero, to);
    }

    // ========= GETTER FUNCTIONS =========
    
    #[test_only]
    public fun hero_name(hero: &Hero): String {
        hero.name
    }

    #[test_only]
    public fun hero_image_url(hero: &Hero): String {
        hero.image_url
    }

    #[test_only]
    public fun hero_power(hero: &Hero): u64 {
        hero.power
    }

    #[test_only]
    public fun hero_id(hero: &Hero): ID {
        object::id(hero)
    }





