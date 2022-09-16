main(){}
//============================================================================== INCLUDES
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
#include <eSelection>
#include <Pawn.Regex>
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
//============================================================================== FORWARDS
forward OnPlayerKick(playerid);
forward checkRegister(playerid);
forward checkPromo(playerid);
//============================================================================== COLORS DIALOGS
#define COLOR_MAIN "4682B4"//��������
#define COLOR_WHITE "FFFFFF"//�����
#define COLOR_BLACK "0E0101" //������
#define COLOR_GREY "C3C3C3"//�����
#define COLOR_GREEN "6EF83C"//�������
#define COLOR_RED "F81414"//�������
#define COLOR_YELLOW "F3FF02"//������
#define COLOR_ORANGE "FFAF00"//���������
#define COLOR_LIME "B7FF00"//������ �������
#define COLOR_LIGHTBLUE "00C0FF"//�������
#define COLOR_BLUE "0049FF"//�����
#define COLOR_LIGHTRED "DC143C"//����-�������
//============================================================================== COLORS CHAT
#define COLOR_REDC 0xAA3333AA 
#define COLOR_GREYC 0xAFAFAFAA 
#define COLOR_YELLOWC 0xFFFF00AA 
#define COLOR_PINKC 0xFF66FFAA 
#define COLOR_BLUEC 0x0000BBAA 
#define COLOR_WHITEC 0xFFFFFFAA 
#define COLOR_LIGHTREDC 0xDC143CAA
//============================================================================== OTHER
#define 	SCM 		SendClientMessage
#define     SCMTA       SendClientMessageToAll
#define     SPD         ShowPlayerDialog
#define 	DSM 		DIALOG_STYLE_MSGBOX
#define 	DSL 		DIALOG_STYLE_LIST
#define 	DSI 		DIALOG_STYLE_INPUT
#define 	DST 		DIALOG_STYLE_TABLIST
#define 	DSTH 		DIALOG_STYLE_TABLIST_HEADERS

//============================================================================== MESSAGE
#define CANCEL_REG		"�� �������� �����������, ��� ������ �� ���� ������� � ��� {"COLOR_WHITE"}/q"
#define CANCEL_LOGIN	"�� �������� �����������, ��� ������ �� ���� ������� � ��� {"COLOR_WHITE"}/q"
//==============================================================================
#define MODEL_SELECTION_SKINS_REGISTER      (0)

#define public:%0(%1) forward%0(%1); public%0(%1) 
/*#define IsValidEmail(%1) \
    regex_match(%1, "[a-zA-Z0-9_\\.]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}")*/

enum PLAYER_INFO
{
	ID,
	Name[MAX_PLAYER_NAME+1],
	Password[16+1],
	Email[64],
	Sex,
	Skin,
	Referal,
	Promo,
	bool: Logged,
	Money,
	IP
}
enum TEMP_INFO
{
	temp_password[64],
	temp_email[64],
	temp_referal[24],
	temp_promo[11]
}
enum
{
	DLG_NONE,
	DLG_LOGIN,
	DLG_REG_PASS,
	DLG_REG_EMAIL,
	DLG_REG_SEX,
	DLG_REG_REFERAL,
	DLG_REG_PROMO,
	DLG_REG_SKIN
}
//============================================================================== OTHER 2
new pInfo[MAX_PLAYERS][PLAYER_INFO];
new TempInfo[MAX_PLAYERS][TEMP_INFO];
new MySQL: connection;

new male_regskins[4] = {2, 4, 5, 7};
new female_regskins[4] = {41, 55, 56, 93};

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
	mysql_log(ALL);
	SetGameModeText(SERVER_VERSION);
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
	if(IsPlayerNPC(playerid))
		return 1;

	SendClientMessage(playerid, COLOR_BLUEC, "����� ����������!");
	new string[256];
	//new query[256];
	//format(query, sizeof(query), "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}*��� ����������� �������� ��������, ��� ���������� ������ ������:");
	//SPD(playerid, DLG_REG_PASS, DSI, "{"COLOR_MAIN"}����������� | ������", query, "�����", "������");
	GetPlayerName(playerid, pInfo[playerid][Name], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, pInfo[playerid][IP], 36);
	format(string, sizeof(string), "SELECT * FROM `accounts` WHERE `name` = '%s' LIMIT 1", pInfo[playerid][Name]);
	mysql_tquery(connection, string, "checkRegister", "d", playerid);
	return 1;
}
public OnPlayerKick(playerid)
{
	return Kick(playerid);
}
public checkRegister(playerid)
{
	new 
		rows = cache_num_rows();

	new string[256 + MAX_PLAYER_NAME];

	if(rows)
	{
		format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������:");
		SPD(playerid, DLG_LOGIN, DSI, "{"COLOR_MAIN"}�����������", string, "�����", "������");
	}
	else {
		format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������:");
		SPD(playerid, DLG_REG_PASS, DSI, "{"COLOR_MAIN"}����������� | ������", string, "�����", "������");
	}
	return 1;
}

public checkPromo(playerid)
{
	new
		rows = cache_num_rows();

	if(rows)
	{
		SPD(playerid, DLG_REG_SKIN, DSI, "{"COLOR_MAIN"}����������� | ��������", "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������� ��� ��������\n{"#COLOR_YELLOW"}* ���� ��, � ��� �� ������� ��������� ���������, ������ ������ *����������*", "�����", "����������");
	}
	else {
		SCM(playerid, COLOR_LIGHTREDC, "������: ������� ��������� �� ����������!");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}
public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, 1685.5687, -2330.9680, 13.5469);
	SetPlayerSkin(playerid, pInfo[playerid][Skin]);
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
	switch(dialogid)
	{
		case DLG_REG_PASS:
		{
			if(response)
			{
				if(strlen(inputtext) < 12 || strlen(inputtext) > 24)
				{
					format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������\n\n{"COLOR_LIGHTRED"}* ������: ����� ������ ������ ����������, �� 12 �� 24 ��������.");
					SPD(playerid, DLG_REG_PASS, DSI, "����������� | ������", string, "�����", "������");
				}
				if(IsTextRussian(inputtext))
				{
					format(string, sizeof(string), "{"COLOR_YELLOW"}*������ ������� �� ��������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, �������\n\n{"COLOR_YELLOW"}* ������: �� ������������ ������� ������� � ������.");
					SPD(playerid, DLG_REG_PASS, DSI, "����������� | ������", string, "�����", "������");
				}
				else 
				{
					format(TempInfo[playerid][temp_password], 24, "%s", inputtext);
					SPD(playerid, DLG_REG_EMAIL, DSI, "{"COLOR_MAIN"}����������� | E-Mail", "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ��� ������������ E-mail\n{"#COLOR_YELLOW"}* ���� ��, � ��� �� ����� E-mail, ������ ������ *����������*", "�����", "����������");

				}
				return 1;
			}
			KickMessage(playerid, COLOR_LIGHTREDC, CANCEL_REG);
		}
		case DLG_REG_EMAIL:
		{
			if(strfind(inputtext, "@", true) || strfind(inputtext, ".", true))
			{
				format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ��� ������������ E-mail\n{"COLOR_LIGHTRED"}* ������: ������ E-Mail �� ����������, ������ �������������� ����� *@ � .*");
				SPD(playerid, DLG_REG_EMAIL, DSI, "{"COLOR_MAIN"}����������� | E-Mail", string, "�����", "����������");
			}
			else
			{
				format(TempInfo[playerid][temp_email], 64, "%s", inputtext);
				SPD(playerid, DLG_REG_SEX, 0, "{"COLOR_MAIN"}����������� | ����� ����", "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, �������� ���", "�������", "�������");
			}
			return 1;
		}
		case DLG_REG_SEX:
		{
			pInfo[playerid][Sex] = ((response) ? 1 : 2);
			SPD(playerid, DLG_REG_REFERAL, DSI, "{"COLOR_MAIN"}����������� | ����������� �������", "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������� ��������� ��������, ������� ��� ���������.\n{"COLOR_YELLOW"}* ���� �� �� ������ � ������� �� ������� ���������, ������ ������ *����������*", "�����", "����������");
			return 1;
		}
		case DLG_REG_REFERAL:
		{
			if(IsTextRussian(inputtext))
			{
				format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� �� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� �������� ��������, ����������, ������� ������� ��������� ��������, ������� ��� ���������.\n{"COLOR_YELLOW"}* ������: �� ������������ ������� �������.");
				SPD(playerid, DLG_REG_REFERAL, DSI, "����������� | ����������� �������", string, "�����", "����������");
			}
			else
			{
				format(string, sizeof(string), "SELECT * FORM `promocods` WHERE `promo` = '%s' LIMIT 1", TempInfo[playerid][temp_promo]);
				mysql_tquery(connection, string, "CheckPromo", "d", playerid);
			}
			return 1;
		}
		case DLG_REG_SKIN:
		{
			format(TempInfo[playerid][temp_promo], 11, "%s", inputtext);
			if(pInfo[playerid][Sex] == 1) ShowModelSelectionMenu(playerid, "MALE SKINS", MODEL_SELECTION_SKINS_REGISTER, male_regskins);
			else if(pInfo[playerid][Sex] == 2) ShowModelSelectionMenu(playerid, "FEMALE SKINS", MODEL_SELECTION_SKINS_REGISTER, female_regskins);
			return 1;
		}
		case DLG_LOGIN:
		{
			if(response)
			{
				if(strlen(inputtext) < 12 || strlen(inputtext) > 24)
				{
					format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� � ������� �������, ����������, ������� ������.\n{"COLOR_LIGHTRED"}* ������: ����� ������ ������ ����������, �� 12 �� 24 ��������.");
					SPD(playerid, DLG_LOGIN, DSI, "�����������", string, "�����", "������");
				}
				if(IsTextRussian(inputtext))
				{
					format(string, sizeof(string), "{"COLOR_YELLOW"}* ������ ������� ���������������.\n{"COLOR_YELLOW"}* ��� ����������� � ������� �������, ����������, ������� ������.\n{"COLOR_LIGHTRED"}* ������: �� ������������ ������� �������.");
					SPD(playerid, DLG_LOGIN, DSI, "����������� | �����������", string, "�����", "����������");
				}
				return 1;
			}
			KickMessage(playerid, COLOR_LIGHTREDC, CANCEL_LOGIN);
		}
	}
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPos(playerid, fX, fY, fZ);
	return 1;
}
public OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{

	if(extraid == MODEL_SELECTION_SKINS_REGISTER && response == MODEL_RESPONSE_SELECT)
	{
		pInfo[playerid][Skin] = modelid;
		new string[256];
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "INSERT INTO `accounts` (`name`, `password`, `email`, `sex`, `referal`, `promo`, `skin`, `logged`, `money`, regip) VALUES ('%s', '%s', '%s', '%d', '%s', '%s', '%d', '%d', '%d', '%s')", name, 
		TempInfo[playerid][temp_password], TempInfo[playerid][temp_email], pInfo[playerid][Sex], TempInfo[playerid][temp_referal], TempInfo[playerid][temp_promo], pInfo[playerid][Skin], 0, 0, pInfo[playerid][IP]);
		mysql_tquery(connection, string, "", "");
		SpawnPlayer(playerid);
	}
}
//=====================================================================================
stock IsTextRussian(text[])
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
stock KickMessage(playerid, color, message[])
{
	SendClientMessage(playerid, color, message);
	SetTimer("OnPlayerKick", 2000, true);
	return true;
}
/*stock IsValidEmail(const email[])
{
  static Regex:regex;
  if (!regex) regex = Regex_New("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");

  return Regex_Check(email, regex);
}*/
//=====================================================================================