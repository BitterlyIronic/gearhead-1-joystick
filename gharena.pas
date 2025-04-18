program GHArena;
	{ This program can hopefully be used as a test for all }
	{ the various GEARHEAD units. I want to make a game similar }
	{ to the old Amiga MechFight game, but based on the }
	{ GearHead engine. }

{
	GearHead: Arena, a roguelike mecha CRPG
	Copyright (C) 2005 Joseph Hewitt

	This library is free software; you can redistribute it and/or modify it
	under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation; either version 2.1 of the License, or (at
	your option) any later version.

	The full text of the LGPL can be found in license.txt.

	This library is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
	General Public License for more details. 

	You should have received a copy of the GNU Lesser General Public License
	along with this library; if not, write to the Free Software Foundation,
	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
}


{$IFDEF SDLMODE}
{$IFNDEF DEBUG}
{$APPTYPE GUI}
{$ENDIF}
uses gears,sdlgfx,arenahq,sdlmenus,randchar,navigate,sdlmap,ghchars,cosplay;
{$ELSE}
uses gears,congfx,arenahq,conmenus,randchar,navigate,context,mapedit;
{$ENDIF}

const
	Version = '1.311j';

var
	RPM: RPGMenuPtr;
	N: Integer;

{$IFDEF SDLMODE}
    MyLogo: SensibleSpritePtr;

Procedure GenNames;
var
    t: Integer;
    mylist: SAttPtr;
begin
    mylist := Nil;
    for t := 1 to 10000 do begin
       StoreSAtt( mylist, RandomName );
    end;
    SaveStringList( 'names.txt', mylist );
    DisposeSAtt( mylist );
end;

Procedure MainMenuRedraw;
    { Draw the opening screen, and add the infobox + logo. }
begin
    RedrawOpening();
    InfoBox( ZONE_TitleScreenMenu.GetRect() );
    DrawSprite( MyLogo, ZONE_TitleScreenLogo.GetRect(), 0 );
    QuickTinyText( Version, ZONE_TitleScreenVersion.GetRect(), BrightYellow );
end;
{$ENDIF}

begin
{$IFDEF SDLMODE}
	RPM := CreateRPGMenu( MenuItem , MenuSelect , ZONE_TitleScreenMenu );
    MyLogo := ConfirmSprite( 'sys_logo.png', '', 500, 218 );
    RPM^.mode := RPMNoCancel;
{$ELSE}
	RPM := CreateRPGMenu( MenuItem , MenuSelect , ZONE_Menu );
{$ENDIF}
	AddRPGMenuItem( RPM , 'Start RPG Campaign' , 4 );
	AddRPGMenuItem( RPM , 'Load RPG Campaign' , 5 );
{$IFNDEF SDLMODE}
	AddRPGMenuItem( RPM , 'New Arena Unit' , 1 );
	AddRPGMenuItem( RPM , 'Load Arena Unit' , 2 );
{$ENDIF}
	AddRPGMenuItem( RPM , 'Create Character' , 3 );
{$IFNDEF SDLMODE}
	AddRPGMenuItem( RPM , 'Edit Map' , 6 );
{$ENDIF}
	AddRPGMenuItem( RPM , 'View Design Files' , 7 );
{$IFDEF SDLMODE}
	AddRPGMenuItem( RPM , 'View Color Selector' , 8 );
{$IFDEF JOYSTICK_SUPPORT}
	if HasJoystick then AddRPGMenuItem( RPM , 'Configure Controller' , 9 );
{$ENDIF}
{$ENDIF}
	AddRPGMenuItem( RPM , 'Quit Game' , -1 );

    {GenNames();}

	repeat
        {$IFNDEF SDLMODE}
		ClrScreen;
        {$ENDIF}

		{ Get rid of the console history from previous games. }
		DisposeSAtt( Console_History );

		CMessage( 'GearHead Arena v' + Version, ZONE_Map, InfoHilight );
		if not STARTUP_OK then DialogMsg( 'ERROR: Main game directories not found. Please check installation of the game.' );
{$IFDEF SDLMODE}
		PrepOpening;
		N := SelectMenu( RPM , @MainMenuRedraw );
{$ELSE}
		N := SelectMenu( RPM );
{$ENDIF}

		case N of
			1:	CreateNewUnit;
			2:	LoadUnit;
			3:	GenerateNewPC;
{$IFDEF SDLMODE}
			4:	StartRPGCampaign( @MainMenuRedraw );
			5:	RestoreCampaign( @MainMenuRedraw );
{$ELSE}
			4:	StartRPGCampaign;
			5:	RestoreCampaign;
{$ENDIF}
{$IFNDEF SDLMODE}
			6:	EditMap;
{$ENDIF}
{$IFDEF SDLMODE}
			7:	DesignDirBrowser( @RedrawOpening );
            8:  DoCosplay;
{$IFDEF JOYSTICK_SUPPORT}
			9:	ConfigureController(@RedrawOpening);
{$ENDIF}
{$ELSE}
			7:	DesignDirBrowser;
{$ENDIF}
		end;
	until N = -1;

	{deallocate all dynamic resources.}
	DisposeRPGMenu( RPM );
end.
