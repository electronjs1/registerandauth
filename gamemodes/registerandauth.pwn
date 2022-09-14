main(){}
//============================================================================== INCLUDES
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
#include <mSelection>
//============================================================================== SETTINGS SERVER
#define SERVER_HOSTNAME             			"TEST"
#define SERVER_VERSION              			"0.0.1"
#define SERVER_MAPNAME              			"San Andreas"
#define SERVER_GROUP                			""
#define SERVER_WEBSITE              			""
#define SERVER_FORUM							""
#define SERVER_LANGUAGE							"Russian"
//============================================================================== MYSQL CONNECT
#define MYSQL_HOST                  			"127.0.0.1"
#define MYSQL_USER                  			"root"
#define MYSQL_PASS                  			""
#define MYSQL_BASE                  			"datebaze"
//============================================================================== COLORS
#define COLOR_RED 0xAA3333AA 
#define COLOR_GREY 0xAFAFAFAA 
#define COLOR_YELLOW 0xFFFF00AA 
#define COLOR_PINK 0xFF66FFAA 
#define COLOR_BLUE 0x0000BBAA 
#define COLOR_WHITE 0xFFFFFFAA 
#define COLOR_DARKRED 0x660000AA 
#define COLOR_ORANGE 0xFF9900AA 
#define COLOR_BRIGHTRED 0xFF0000AA 
#define COLOR_INDIGO 0x4B00B0AA 
#define COLOR_VIOLET 0x9955DEEE 
#define COLOR_LIGHTRED 0xFF99AADD 
#define COLOR_SEAGREEN 0x00EEADDF 
#define COLOR_GRAYWHITE 0xEEEEFFC4 
#define COLOR_LIGHTNEUTRALBLUE 0xabcdef66 
#define COLOR_GREENISHGOLD 0xCCFFDD56 
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349 
#define COLOR_NEUTRALBLUE 0xABCDEF01 
#define COLOR_LIGHTCYAN 0xAAFFCC33 
#define COLOR_LEMON 0xDDDD2357 
#define COLOR_MEDIUMBLUE 0x63AFF00A 
#define COLOR_NEUTRAL 0xABCDEF97 
#define COLOR_BLACK 0x00000000 
#define COLOR_NEUTRALGREEN 0x81CFAB00 
#define COLOR_DARKGREEN 0x12900BBF 
#define COLOR_LIGHTGREEN 0x24FF0AB9 
#define COLOR_DARKBLUE 0x300FFAAB 
#define COLOR_BLUEGREEN 0x46BBAA00 
#define COLOR_PINK 0xFF66FFAA 
#define COLOR_LIGHTBLUE 0x33CCFFAA 
#define COLOR_DARKRED 0x660000AA 
#define COLOR_ORANGE 0xFF9900AA 
#define COLOR_PURPLE 0x800080AA 
#define COLOR_GRAD1 0xB4B5B7FF 
#define COLOR_GRAD2 0xBFC0C2FF 
#define COLOR_RED1 0xFF0000AA 
#define COLOR_GREY 0xAFAFAFAA 
#define COLOR_GREEN 0x33AA33AA 
#define COLOR_RED 0xAA3333AA 
#define COLOR_YELLOW 0xFFFF00AA 
#define COLOR_WHITE 0xFFFFFFAA 
#define COLOR_BROWN 0x993300AA 
#define COLOR_CYAN 0x99FFFFAA 
#define COLOR_TAN 0xFFFFCCAA 
#define COLOR_PINK 0xFF66FFAA 
#define COLOR_KHAKI 0x999900AA 
#define COLOR_LIME 0x99FF00AA 
#define COLOR_SYSTEM 0xEFEFF7AA 
#define COLOR_GRAD2 0xBFC0C2FF 
#define COLOR_GRAD4 0xD8D8D8FF 
#define COLOR_GRAD6 0xF0F0F0FF 
#define COLOR_GRAD2 0xBFC0C2FF 
#define COLOR_GRAD3 0xCBCCCEFF 
#define COLOR_GRAD5 0xE3E3E3FF 
#define COLOR_GRAD1 0xB4B5B7FF 
//============================================================================== OTHER
#define 	SCM 		SendClientMessage
#define     SCMTA       SendClientMessageToAll
#define     SPD         ShowPlayerDialog
#define 	DSM 		DIALOG_STYLE_MSGBOX
#define 	DSL 		DIALOG_STYLE_LIST
#define 	DSI 		DIALOG_STYLE_INPUT
#define 	DST 		DIALOG_STYLE_TABLIST
#define 	DSTH 		DIALOG_STYLE_TABLIST_HEADERS

#define MODEL_SELECTION_SKINS_REGISTER      (1)


#define public:%0(%1) forward%0(%1); public%0(%1) 
enum PLAYER_INFO
{
	ID,
	Name[MAX_PLAYER_NAME+1],
	Password[16+1],
	Email[64],
	Sex,
	Skin,
	bool: Logged,
	Money
}
enum TEMP_INFO
{
	temp_password[64];
	temp_email[64];
}
enum
{
	DLG_NONE,
	DLG_LOGIN,
	DLG_REG_PASS,
	DLG_REG_EMAIL,
	DLG_REG_SEX,
	DLG_REG_REFERAL,
	DLG_REG_PROMO
}
//============================================================================== OTHER 2
new pInfo[MAX_PLAYERS][PLAYER_INFO];
new TempInfo[MAX_PLAYERS][TEMP_INFO];
new MySQL: connection;

////////////////////////////////////////////////////////////////////////////////
public OnGameModeInit()
{
	connection = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_BASE);
	if(mysql_errno() != 0)
	{
		print("[MySQL] ����������� �����������!");
		return SendRconCommand("exit");
	}
	else
	{
		print("[MySQL] ����������� ������������!");
	}
	SetGameModeText(SERVER_VERSION);
	OnPlayerSpawn();
	SendRconCommand("hostname "SERVER_HOSTNAME"");
	SendRconCommand("mapname "SERVER_MAPNAME"");
	SendRconCommand("weburl "SERVER_WEBSITE"");
	SendRconCommand("language "SERVER_LANGUAGE"");
	return 1;
}
public OnGameModeExit()
{
	mysql_close(connection);
    return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}
public OnPlayerConnect(playerid)
{
	new string[126];
	SCM(playerid, COLOR_BLUEGREEN, "����� ���������� �� ������� {"#COLOR_YELLOW"}"SERVER_HOSTNAME".");
	GetPlayerName(playerid, pInfo[playerid][Name], MAX_PLAYER_NAME);
	mysql_format(connection, string, sizeof string, "SELECT * FROM `accounts` WHERE `name` = '%s' LIMIT 1", pInfo[playerid][Name])
	mysql_query(connection, string, playerid)
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}
public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, 1562.0521, 1613.3821, 15.4728);
	SetPlayerCameraPos(playerid, 1562.0521, 1613.3821, 15.4728);
	SetPlayerCameraLookAt(playerid, 1562.0521, 1613.3821, 15.4728);
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
	return 1;
}
public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}
public OnPlayerText(playerid, text[])
{
	return 1;
}
/*public OnPlayerCommandText(playerid, cmdtext[])
{
	
}*/
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}
public OnRconCommand(cmd[])
{
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	return 1;
}
public OnObjectMoved(objectid)
{
	return 1;
}
public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}
public OnPlayerExitedMenu(playerid)
{
	return 1;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}
public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}
public OnPlayerUpdate(playerid)
{
	return 1;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}
public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[1024];
	DLG_REG_PASS:
	{
		if(!response)
		{
			if(!(12 <= strlen(inputtext) <= 24))
			{
				format(string, sizeof(string), "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ������\n\n{"#COLOR_LIGHTRED"}������: ����� ������ ������ ����������, �� 12 �� 24 ��������");
				SPD(playerid, DLG_REG_PASS, DSI, "{"#COLOR_BLUE"}����������� | ������", string, "�����", "������");
			}
			if(IsTextRussian(inputtext))
			{
				format(string, sizeof(string), "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ������\n\n{"#COLOR_LIGHTRED"}������: ���������� ������������ ������� �������");
				SPD(playerid, DLG_REG_PASS, DSI, "{"#COLOR_BLUE"}����������� | ������", string, "�����", "������");
			}
			else
			{
				format(TempInfo[playerid][temp_password], 16, "%s", inputtext);
				SPD(playerid, DLG_REG_EMAIL, DSI, "����������� | E-Mail", "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ��� ������������ E-mail\n{"#COLOR_BLUE"}���� ��, � ��� �� ����� E-mail, ������ ������ *����������*", "�����", "����������");
				//SPD(playerid, DLG_REG_REFERAL, DSI, "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ������� ��������� ��������, ������� ��� ���������.\n{"#COLOR_BLUE"}���� �� �� ������ � ������� �� ������� ���������, ������ ������ *����������*", "�����", "����������");
			}
		}
	}
	DLG_REG_EMAIL:
	{
		if(!response)
		{
			if(strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1)
			{
				format(string, sizeof(string), "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ��� ������������ E-mail\n{"#COLOR_LIGHTRED"}������: ������ E-Mail �� ����������, ������ �������������� ����� *@ � .*");
				SPD(playerid, DLG_REG_EMAIL, DSI, "����������� | E-Mail", string, "�����", "����������");
			}
			if(IsTextRussian(inputtext))
			{
				format(string, sizeof(string), "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ��� ������������ E-mail\n{"#COLOR_LIGHTRED"}������: ������ E-Mail �� ����������, ������ �������������� ����� *@ � .*");
				SPD(playerid, DLG_REG_EMAIL, DSI, "����������� | E-Mail", string, "�����", "����������");
			}
			else
			{
				format(TempInfo[playerid][temp_email], 16, "%s", inputtext);
				SPD(playerid, DLG_REG_EMAIL, 0, "����������� | ����� ����", "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, �������� ���", "�������", "�������");
			}
		}
	}
	DLG_REG_SEX:
	{
		pInfo[playerid][Sex] = ((response) ? 1 : 2)
		SPD(playerid, DLG_REG_REFERAL, DSI, "{"#COLOR_YELLOW"}������ ������� �� ���������������.\n{"#COLOR_YELLOW"}��� ����������� �������� ��������, ����������, ������� ������� ��������� ��������, ������� ��� ���������.\n{"#COLOR_BLUE"}���� �� �� ������ � ������� �� ������� ���������, ������ ������ *����������*", "�����", "����������");
	}
	DLG_REG_REFERAL:
	{
		
	}
	DLG_REG_PROMO:
	{

	}
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}
//=====================================================================================
IsTextRussian(text[])
{
	if(strfind(text, "a", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "e", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	if(strfind(text, "�", true) != -1) return true;
	return false;
}
//=====================================================================================