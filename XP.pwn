#define FILTERSCRIPT
#include <a_samp>
#include <y_ini>
#include <zcmd>
#include <sscanf>

#define PATH "XPUsers/%.ini"

// Experience - System [Y_INI] //

enum pInfo
{
	 XP
}
new PlayerInfo[MAX_PLAYERS][pInfo];

forward LoadUser_XP(playerid,name[],value[]);
public LoadUser_XP(playerid,name[],value[])
{
	INI_Int("XP",PlayerInfo[playerid][XP]);
    return 1;
}

stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}


new Text:Textdraw0;
new Text:Textdraw1[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("Loading Experience system...");
	print("RyderX's Experience system loaded!");

	// Create the textdraws:
	Textdraw0 = TextDrawCreate(510.000000, 390.000000, "EXPERIENCE:");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 3);
	TextDrawLetterSize(Textdraw0, 0.529999, 1.800000);
	TextDrawColor(Textdraw0, 65535);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);

	for(new i; i < MAX_PLAYERS; i ++)
	{

	Textdraw1[i] = TextDrawCreate(511.000000, 417.000000, "");
	TextDrawBackgroundColor(Textdraw1[i], 255);
	TextDrawFont(Textdraw1[i], 0);
	TextDrawLetterSize(Textdraw1[i], 0.519999, 1.900000);
	TextDrawColor(Textdraw1[i], 16777215);
	TextDrawSetOutline(Textdraw1[i], 1);
	TextDrawSetProportional(Textdraw1[i], 1);
		
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1[playerid]);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, 0xfff888f88, "Welcome! This server is using EXP system! kill other to get More XPs!");
	return 1;
}

public OnPlayerUpdate(playerid)
{
    new string[128];
    format(string, sizeof(string), "%d", PlayerInfo[playerid][XP]);
    TextDrawSetString(Textdraw1[playerid], string);
    TextDrawShowForPlayer(playerid, Textdraw1[playerid]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
        new string[250]; new name[MAX_PLAYER_NAME]; new kname[MAX_PLAYER_NAME]; 
        GetPlayerName(playerid, name,sizeof(name));
		GetPlayerName(killerid, kname,sizeof(kname));
        format(string,sizeof(string),"-DM- {F00f00}%s(%i) {ffffff}has killed {f00f00}%s(%i) {FFFFFF}and got {f00f00} +2 XP!",kname,killerid,name,playerid);
        SendClientMessageToAll(0xf8f8f8fff,string);
        PlayerInfo[killerid][XP] += 2; //you can change XP's value as the amount you want.
        return 1;
}

//COMMANDS//
CMD:givexp(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
    {
		new targetid;
		new maxxp;
		new string[128];
		new pname[MAX_PLAYER_NAME];
		new tname[MAX_PLAYER_NAME];
		if(sscanf(params, "ii", targetid, maxxp)) return SendClientMessage(playerid, 0xF8F8F8FFF, "Syntax: {F00f00}/givexp [ID] [amount]");
        if((!IsPlayerConnected(targetid)) || (targetid == INVALID_PLAYER_ID)) return SendClientMessage(playerid, 0xFF0000, "ERROR: {FFFFFF}Player isn't Connected!");
        if(maxxp < 0 || maxxp > 100000) return SendClientMessage(playerid, 0xF8F8F8FFF, "ERROR: {FFFFFF}highest amount is 100000.");
        GetPlayerName(playerid, pname, sizeof(pname));
        GetPlayerName(targetid, tname, sizeof(tname));
        format(string, sizeof(string), "{99bec3}Administrator {FFD700}%s {99bec3}has {15ff00}gave {FFD700}%s {FFD700}%i {99bec3}XP!", pname, tname, maxxp);
        SendClientMessageToAll(0xF8F8F8FFF, string);
        GameTextForPlayer(targetid,"~W~W~P~O~R~W! ~Y~N~G~I~R~C~P~E! ~Y~X~P~P ~R~:)",3000,3);
        new INI:File = INI_Open(UserPath(targetid));
        PlayerInfo[targetid][XP] += maxxp;
        INI_WriteInt(File,"XP",maxxp);
   	    INI_Close(File);
    }
    else
    {
	    SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFFFF}You aren't authorized to use this command.");
	}
    return 1;
}

CMD:setxp(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
    {
	    new targetid;
		new maxxp;
		new string[128];
		new pname[MAX_PLAYER_NAME];
		new tname[MAX_PLAYER_NAME];

		if(sscanf(params, "ii", targetid, maxxp)) return SendClientMessage(playerid, 0xF8F8F8FFF, "Syntax: {F00f00}/setxp [ID] [amount]");
        if((!IsPlayerConnected(targetid)) || (targetid == INVALID_PLAYER_ID)) return SendClientMessage(playerid, 0xFF0000, "ERROR: {FFFFFF}Player isn't Connected!");
        if(maxxp < 0 || maxxp > 1000000) return SendClientMessage( playerid, 0xF8F8F8FFF, "ERROR: {FFFFFF}highest amount is 1000000.");
        GetPlayerName(playerid, pname, sizeof(pname));
        GetPlayerName(targetid, tname, sizeof(tname));
        format(string, sizeof(string), "{99bec3}Administrator {FFD700}%s {99bec3}has set {FFD700}%s {15ff00}XP {99bec3}Amount to {FFD700}%i{99bec3}.", pname, tname, maxxp);
        SendClientMessageToAll(0xF8F8F8FFF, string);
        new INI:File = INI_Open(UserPath(targetid));
        PlayerInfo[targetid][XP] = maxxp;
        INI_WriteInt(File,"XP",maxxp);
   	    INI_Close(File);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFFFF}You aren't authorized to use this command.");
	}
    return 1;
}
