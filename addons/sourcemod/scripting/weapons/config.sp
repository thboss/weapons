/*  CS:GO Weapons&Knives SourceMod Plugin
 *
 *  Copyright (C) 2017 Kağan 'kgns' Üstüngel
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

public void ReadConfig()
{
	if(g_smWeaponIndex != null) delete g_smWeaponIndex;
	g_smWeaponIndex = new StringMap();
	if(g_smWeaponDefIndex != null) delete g_smWeaponDefIndex;
	g_smWeaponDefIndex = new StringMap();
	if(g_smVipSkins != null) delete g_smVipSkins;
	g_smVipSkins = new StringMap();
	
	for (int i = 0; i < sizeof(g_WeaponClasses); i++)
	{
		g_smWeaponIndex.SetValue(g_WeaponClasses[i], i);
		g_smWeaponDefIndex.SetValue(g_WeaponClasses[i], g_iWeaponDefIndex[i]);
	}
	
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/weapons/weapons.cfg");
		
	KeyValues kv = CreateKeyValues("ws");
	FileToKeyValues(kv, configPath);
		
	if (!KvGotoFirstSubKey(kv))
	{
		SetFailState("CFG File not found: %s", configPath);
		CloseHandle(kv);
	}
	
	for (int k = 0; k < sizeof(g_WeaponClasses); k++)
	{
		if(menuWeapons[k] != null)
		{
			delete menuWeapons[k];
		}
		menuWeapons[k] = new Menu(WeaponsMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_DrawItem|MenuAction_DisplayItem);
		menuWeapons[k].SetTitle("%T", g_WeaponClasses[k], LANG_SERVER);
		menuWeapons[k].AddItem("0", "Default");
		menuWeapons[k].ExitBackButton = true;
	}

	do {
		char name[64];
		char id[4];
		char weapon[1024];
		char vipGroups[64];
		char buffer[8];
			
		KvGetSectionName(kv, name, sizeof(name));
		KvGetString(kv, "weapon", weapon, sizeof(weapon));
		KvGetString(kv, "id", id, sizeof(id));
		KvGetString(kv, "vip", vipGroups, sizeof(vipGroups));

		for (int k = 0; k < sizeof(g_WeaponClasses); k++)
		{
			if(StrEqual(weapon, g_WeaponClasses[k]))
			{
				Format(buffer, sizeof(buffer), "%i_%s", g_iWeaponDefIndex[k], id);
				g_smVipSkins.SetString(buffer, vipGroups);
				menuWeapons[k].AddItem(id, name);
			}
		}
	} while (KvGotoNextKey(kv));
		
	CloseHandle(kv);
}
