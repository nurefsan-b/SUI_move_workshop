module module_2::hero {
    use std::string::String;
    
     public struct Hero has key, store {
        // TODO: Add the fields for the Hero
        id :UID, // 1. The id of the Hero
        name :String, // 2. The name of the Hero
        image_url :String, // 3. The imageurl of the Hero
        power :u64 // 4. The power of the Hero
    }

    #[allow(lint(self_transfer))]
    public entry fun create_hero(name: String, image_url: String, power: u64,  ctx: &mut TxContext) {
       let hero = Hero { 
        id: object::new(ctx), 
        name, 
        image_url,
        power ,
        }; // TODO: Create the Hero object
        // TODO: Transfer the Hero object to the sender
        transfer::public_transfer(hero,tx_context::sender(ctx));
    }


    public entry fun transfer_hero(hero: Hero, to: address) {
        // TODO: Transfer the Hero object to the recipient
        transfer::public_transfer(hero,to);
       
    }
    
    // ========= GETTER FUNCTIONS =========

    #[test_only]
    public fun hero_name(hero: &Hero): String {
        hero.name
    }

    #[test_only]
    public fun hero_power(hero: &Hero): u64 {
        hero.power
    }
    
    #[test_only]
    public fun hero_image_url(hero: &Hero): String {
        hero.image_url
    }
}
