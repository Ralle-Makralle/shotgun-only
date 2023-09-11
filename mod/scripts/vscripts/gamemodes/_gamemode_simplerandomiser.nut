global function GamemodeRand_Init

void function GamemodeRand_Init()
{
    #if SERVER
    SetLoadoutGracePeriodEnabled( false ) // prevent modifying loadouts with grace period
    SetWeaponDropsEnabled( false ) // prevents picking up weapons on the ground
    AddCallback_OnPlayerRespawned( GiveRandomGun )
    #endif
}

array<string> pilotWeapons = ["mp_weapon_alternator_smg",
                              "mp_weapon_autopistol",
                              "mp_weapon_car",
                              "mp_weapon_dmr"]

void function GiveRandomGun(entity player)
{
    foreach ( entity weapon in player.GetMainWeapons() )
        player.TakeWeaponNow( weapon.GetWeaponClassName() )

    player.GiveWeapon( pilotWeapons[ RandomInt( pilotWeapons.len() ) ] )

    // checks if the toggle option is set to enabled
    if ( GetCurrentPlaylistVarInt( "rand_enableannouncements", 1 ) == 1 )
        Remote_CallFunction_NonReplay( player, "ServerCallback_Randomiser", GetCurrentPlaylistVarFloat( "rand_announcementduration", 3 ) ) // call the function that will be used client-side
}