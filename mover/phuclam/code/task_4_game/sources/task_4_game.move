module task_4_game::task_4_game{
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use faucet_token::faucet_token::FAUCET_TOKEN;
    use sui::random::{Self, Random};

    public struct Game has key {
        id: UID,
        balance: Balance<FAUCET_TOKEN>
    }

    public struct Admin has key {
        id: UID,
    }

    fun init (ctx: &mut TxContext){

      transfer::share_object(Game{
            id: object::new(ctx),
            balance: balance::zero<FAUCET_TOKEN>()
        });

     transfer::transfer(Admin{
        id: object::new(ctx)
     }, ctx.sender());
    }

    entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_TOKEN>, amount : u64){
        let spli_balance =  balance::split(coin::balance_mut(coin), amount);
        balance::join( &mut game.balance, spli_balance);
    }

    entry fun withdraw(game: &mut Game,_: &Admin,  amount : u64 ,ctx: &mut TxContext){
        let cash = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(cash, ctx.sender());
    }
     
    entry fun play(
        game:  &mut Game,
        random: &Random,
        guess: bool,
        coin: &mut Coin<FAUCET_TOKEN>,   
        ctx: &mut TxContext
    ){
        let mut newRandom = random::new_generator(random, ctx);
        let flag = random::generate_bool( &mut newRandom );

        if(flag == guess){
            let reward =  coin::take(&mut game.balance, 100000000, ctx);
            coin::join(coin, reward);
        }
        else{
            deposit(game, coin, 100000000);
        }
    }










}
  
