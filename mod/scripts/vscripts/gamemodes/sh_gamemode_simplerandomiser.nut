global function simplerandomiser_init
global const string GAMEMODE_SIMPLERRANDOMISER = "rand"

void function simplerandomiser_init()
{
    addCallback_OnCustomGamemodesInit( CreateGamemodeRand )
    AddCallback_OnRegisteringCustomNetworkVars( RandRegisterNetworkVars )
}

void function CreateGamemodeRand()
{
    GameMode_Create( GAMEMODE_SIMPLERANDOMISER )
    GameMode_SetName( GAMEMODE_SIMPLERANDOMISER, "#GAMEMODE_SIMPLERANDOMISER" ) // localizations will be handled later
    GameMode_SetDesc( GAMEMODE_SIMPLERANDOMISER, "#PL_rand_desc" )
    GameMode_SetGameModeAnnouncement( GAMEMODE_SIMPLERANDOMISER, "grnc_modeDesc" )
    GameMode_SetDefaultTimeLimits( GAMEMODE_SIMPLERANDOMISER, 15, 0.0 ) // a time limit of 10 minutes
    GameMode_AddScoreboardColumnData( GAMEMODE_SIMPLERANDOMISER, "#SCOREBOARD_SCORE", PGS_ASSAULT_SCORE, 2 ) // dont fuck with it
    GameMode_AddScoreboardColumnData( GAMEMODE_SIMPLERANDOMISER, "#SCOREBOARD_PILOT_KILLS", PGS_PILOT_KILLS, 2 ) // dont fuck with it
    GameMode_SetColor( GAMEMODE_SIMPLERANDOMISER, [147, 204, 57, 255] ) // dont fuck with it

    AddPrivateMatchMode( GAMEMODE_SIMPLERANDOMISER ) // add to private lobby modes

    AddPrivateMatchModeSettingEnum("#PL_rand", "rand_enableannouncements", ["#SETTING_DISABLED", "#SETTING_ENABLED"], "1")
    // creates a togglable riff whether or not we want to announce a text to the client
    AddPrivateMatchModeSettingArbitrary("#PL_rand", "rand_announcementduration", "3")
    // Creates a riff with an arbitrary numerical value for how long the announcement text remains on screen
    // These riffs can be accessed from server configs or from the private match settings screen, under the "Simple Randomiser" category


    // set this to 25 score limit default
    GameMode_SetDefaultScoreLimits( GAMEMODE_SIMPLERANDOMISER, 25, 0 )

    #if SERVER
            GameMode_AddServerInit( GAMEMODE_SIMPLERANDOMISER, GamemodeRand_Init ) // server side initalizing function
            GameMode_SetPilotSpawnpointsRatingFunc( GAMEMODE_SIMPLERANDOMISER, RateSpawnpoints_Generic )
            GameMode_SetTitanSpawnpointsRatingFunc( GAMEMODE_SIMPLERANDOMISER, RateSpawnpoints_Generic )
            // until northstar adds more spawnpoints algorithm, we are using the default.
    #elseif CLIENT
            GameMode_AddClientInit( GAMEMODE_SIMPLERANDOMISER, ClGamemodeRand_Init ) // client side initializing function
    #endif
    #if !UI
            GameMode_SetScoreCompareFunc( GAMEMODE_SIMPLERANDOMISER, CompareAssaultScore )
            // usually compares which team's score is higher and places the winning team on top of the losing team in the scoreboard
    #endif
}

void function RandRegisterNetworkVars()
{
    if ( GAMETYPE != GAMEMODE_SIMPLERANDOMISER )
            return

    Remote_RegisterFunction( "ServerCallback_Randomiser" )
    // will come in useful later when we want the server to communicate to the client
    // for example, making an announcement appear on the client
}