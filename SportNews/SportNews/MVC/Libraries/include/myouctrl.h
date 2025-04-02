#ifndef UPNP_MYOUCTRL_H
#define UPNP_MYOUCTRL_H

/**************************************************************************
 *
 * Copyright (c) 2000-2003 Intel Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * - Neither name of Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 **************************************************************************/

/*!
 * \addtogroup UpnpSamples
 *
 * @{
 *
 * \name Contro Point Sample API
 *
 * @{
 *
 * \file
 */

#ifdef __cplusplus
extern "C" {
#endif

#include "sample_util.h"

#include "upnp.h"
#include "UpnpString.h"
#include "upnptools.h"

#include <signal.h>
#include <stdarg.h>
#include <stdio.h>


//--------------------------------------------------------------------------------------
#define ENABLE_CONSOLE_EXE	1
//--------------------------------------------------------------------------------------


#define TV_SERVICE_SERVCOUNT	3
//#define TV_SERVICE_CONTROL	0
//#define TV_SERVICE_PICTURE	1
#define TV_SERVICE_AVTRANSPORT			0
#define TV_SERVICE_CONNECTIONMANAGER	1
#define TV_SERVICE_RENDINGCONTROL		2
#define TV_SERVICE_GENERALCONTROL		3


#define ACTION_SETAVTRANSURI		"SetAVTransportURI"
#define ACTION_SETNEXTAVTRANSURI	"SetNextAVTransportURI"
#define ACTION_GETMEDIAINFO			"GetMediaInfo"
#define ACTION_GETRANSINFO			"GetTransportInfo"
#define ACTION_GETPOSINFO			"GetPositionInfo"
#define ACTION_GETDEVICECAPS		"GetDeviceCapabilities"
#define ACTION_GETTRANSSETTINGS		"GetTransportSettings"
#define ACTION_STOP					"Stop"
#define ACTION_PLAY					"Play"
#define ACTION_PAUSE				"Pause"
#define ACTION_RECORD				"Record"
#define ACTION_SEEK					"Seek"
#define ACTION_NEXT					"Next"
#define ACTION_PREVIOUS				"Previous"
#define ACTION_SETPLAYMODE			"SetPlayMode"
#define ACTION_SETRECQAMODE			"SetRecordQualityMode"
#define ACTION_GETTRANSACTIONS		"GetCurrentTransportActions"

#define ACTION_GETMUTE 				"GetMute"
#define ACTION_SETMUTE 				"SetMute"
#define ACTION_GETVOLUME 			"GetVolume"
#define ACTION_SETVOLUME 			"SetVolume"



/*#define TV_CONTROL_VARCOUNT	3
#define TV_CONTROL_POWER	0
#define TV_CONTROL_CHANNEL	1
#define TV_CONTROL_VOLUME	2

#define TV_PICTURE_VARCOUNT	4
#define TV_PICTURE_COLOR	0
#define TV_PICTURE_TINT		1
#define TV_PICTURE_CONTRAST	2
#define TV_PICTURE_BRIGHTNESS	3*/
#define TV_AVTRANSPORT_VARCOUNT			29
#define TV_CONNECTIONMANAGER_VARCOUNT	12
#define TV_RENDINGCONTROL_VARCOUNT		21
#define TV_GENERALCONTROL_VARCOUNT		4


#define TV_CTR_MAX_VAL_LEN		1024

#define TV_SUCCESS		0
#define TV_ERROR		(-1)
#define TV_WARNING		1

/* This should be the maximum VARCOUNT from above */
//#define TV_MAXVARS		TV_PICTURE_VARCOUNT
#define TV_CTR_MAXVARS		TV_AVTRANSPORT_VARCOUNT

extern const char *TvServiceName[];
extern const char *TvVarName[TV_SERVICE_SERVCOUNT][TV_CTR_MAXVARS];
extern char TvVarCount[];

typedef struct TransportInfo {
    char state[16];
    char status[16];
    char speed[16];
}TransportInfo;

typedef struct PositionInfo {
    char track[16];
    char duration[16];
    char metaData[2048];
	char trackURI[2048];
	char relTime[16];
	char AbsTime[16];
	char relCounter[16];
	char absCounter[16];
}PositionInfo;

struct tv_service {
    char ServiceId[NAME_SIZE];
    char ServiceType[NAME_SIZE];
    char *VariableStrVal[TV_CTR_MAXVARS];
    char EventURL[NAME_SIZE];
    char ControlURL[NAME_SIZE];
    char SID[NAME_SIZE];
};

extern struct TvDeviceNode *GlobalDeviceList;

struct TvDevice {
    char UDN[250];
    char DescDocURL[250];
    char FriendlyName[250];
    char PresURL[250];
    int  AdvrTimeOut;
    struct tv_service TvService[TV_SERVICE_SERVCOUNT];
};

struct TvDeviceNode {
    struct TvDevice device;
    struct TvDeviceNode *next;
};

extern ithread_mutex_t DeviceListMutex;

extern UpnpClient_Handle ctrlpt_handle;

#define DMC_ACTION_DMRDEVICE_UPDATE	1001
#define DMC_EVENT_RECEIVED_UPDATE	2001

typedef int (*dpsCtrlCallBack)(
	int Action,
	int NumArg,
	const char *Argname1,
	const char *Argvalue1,
	const char *Argname2,
	const char *Argvalue2,
	const char *Argname3,
	const char *Argvalue3,
	const char *Argname4,
	const char *Argvalue4);

void dpsCtrlSetActionCallBack(dpsCtrlCallBack pfuncb, char *appid);

typedef char*(*MYOUCtrlCallBack)(
	int Action,
	int NumArg,
	const char *Arg,
	...);

void MYOUCtrlSetActionCallBack(MYOUCtrlCallBack pfuncb, char *appid);
void MYOUCtrlSetInfo(char *appid, char *secret, char *applicationid);
char *MYOUCtrlPointGetIP();
unsigned short MYOUCtrlPointGetPort();


void	TvCtrlPointPrintHelp(void);
int		TvCtrlPointDeleteNode(struct TvDeviceNode *);
int		TvCtrlPointRemoveDevice(const char *);
int		TvCtrlPointRemoveAll(void);
int		MYOUCtrlPointRefresh(void);

int		TvCtrlPointSendAction(int, int, const char *, const char **, char **, int);
int		TvCtrlPointSendActionNumericArg(int devnum, int service, const char *actionName, const char *paramName, int paramValue);

int dpsCtrlPointSetAVTransportURI(
	int service,
	const char *UDN,
	int instanceid,
	const char *uri,
	const char *urimetadata);
int dpsCtrlPointPlay(
	int service,
	const char *UDN,
	int instanceid,
	const char *speed);
int dpsCtrlPointPause(
	int service,
	const char *UDN,
	int instanceid);
int dpsCtrlPointStop(
	int service,
	const char *UDN,
	int instanceid);
int dpsCtrlPointSeek(
	int service,
	const char *UDN,
	int instanceid,
	const char *unit,
	const char *target);
int dpsCtrlPointGetTransportInfo(
	int service,
	const char *UDN,
	int instanceid,
	TransportInfo *ptransportInfo);
int dpsCtrlPointGetPositionInfo(
	int service,
	const char *UDN,
	int instanceid,
	PositionInfo *pPositionInfo);
int dpsCtrlPointGetMute(
	int service,
	const char *UDN,
	int instanceid);
int dpsCtrlPointSetMute(
	int service,
	const char *UDN,
	int instanceid,
	int desiredmute);
int dpsCtrlPointGetVolume(
	int service,
	const char *UDN,
	int instanceid);
int dpsCtrlPointSetVolume(
	int service,
	const char *UDN,
	int instanceid,
	int desiredvolume);


int MYOUCtrlPointSetAVTransportURI(
	int service,
	int devnum,
	int instanceid,
	const char *uri,
	const char *urimetadata);
int MYOUCtrlPointPlay(
	int service,
	int devnum,
	int instanceid,
	const char *speed);
int MYOUCtrlPointPause(
	int service,
	int devnum,
	int instanceid);
int MYOUCtrlPointStop(
	int service,
	int devnum,
	int instanceid);
int MYOUCtrlPointSeek(
	int service,
	int devnum,
	int instanceid,
	const char *unit,
	const char *target);
int MYOUCtrlPointGetTransportInfo(
	int service,
	int devnum,
	int instanceid,
	TransportInfo *ptransportInfo);
int MYOUCtrlPointGetPositionInfo(
	int service,
	int devnum,
	int instanceid,
	PositionInfo *pPositionInfo);
int MYOUCtrlPointGetMute(
	int service,
	int devnum,
	int instanceid);
int MYOUCtrlPointSetMute(
	int service,
	int devnum,
	int instanceid,
	int desiredmute);
int MYOUCtrlPointGetVolume(
	int service,
	int devnum,
	int instanceid);
int MYOUCtrlPointSetVolume(
	int service,
	int devnum,
	int instanceid,
	int desiredvolume);

#if 0
int		TvCtrlPointSendPowerOn(int devnum);
int		TvCtrlPointSendPowerOff(int devnum);
int		TvCtrlPointSendSetChannel(int, int);
int		TvCtrlPointSendSetVolume(int, int);
int		TvCtrlPointSendSetColor(int, int);
int		TvCtrlPointSendSetTint(int, int);
int		TvCtrlPointSendSetContrast(int, int);
int		TvCtrlPointSendSetBrightness(int, int);
#endif
int		TvCtrlPointGetVar(int, int, const char *);
#if 0
int		TvCtrlPointGetPower(int devnum);
int		TvCtrlPointGetChannel(int);
int		TvCtrlPointGetVolume(int);
int		TvCtrlPointGetColor(int);
int		TvCtrlPointGetTint(int);
int		TvCtrlPointGetContrast(int);
int		TvCtrlPointGetBrightness(int);
#endif
int 	dpsCtrlPointGetDevice(const char *UDN, struct TvDeviceNode **devnode);
int		TvCtrlPointGetDevice(int, struct TvDeviceNode **);
int 	MYOUCtrlPointGetDevice(struct TvDeviceNode **devnode);
int		MYOUCtrlPointPrintList(void);
int		MYOUCtrlPointPrintDevice(int);
void	TvCtrlPointAddDevice(IXML_Document *, const char *, int); 
void    TvCtrlPointHandleGetVar(const char *, const char *, const DOMString);

/*!
 * \brief Update a Tv state table. Called when an event is received.
 *
 * Note: this function is NOT thread save. It must be called from another
 * function that has locked the global device list.
 **/
void TvStateUpdate(
	/*! [in] The UDN of the parent device. */
	char *UDN,
	/*! [in] The service state table to update. */
	int Service,
	/*! [out] DOM document representing the XML received with the event. */
	IXML_Document *ChangedVariables,
	/*! [out] pointer to the state table for the Tv  service to update. */
	char **State);

void TvCtrlPointHandleEvent(const char *, int, IXML_Document *);
void TvCtrlPointHandleSubscribeUpdate(const char *, const Upnp_SID, int);
int TvCtrlPointCallbackEventHandler(Upnp_EventType, const void *, void *);

/*!
 * \brief Checks the advertisement each device in the global device list.
 *
 * If an advertisement expires, the device is removed from the list.
 *
 * If an advertisement is about to expire, a search request is sent for that
 * device.
 */
void TvCtrlPointVerifyTimeouts(
	/*! [in] The increment to subtract from the timeouts each time the
	 * function is called. */
	int incr);

void	TvCtrlPointPrintCommands(void);
void*	TvCtrlPointCommandLoop(void *);
int		MYOUCtrlPointStart(char *iface, const char *ip_address, unsigned short port, state_update updateFunctionPtr, int combo);
int		MYOUCtrlPointExit(void);
int		TvCtrlPointProcessCommand(char *cmdline);

/*!
 * \brief Print help info for this application.
 */
void MYOUCtrlPointPrintShortHelp(void);

/*!
 * \brief Print long help info for this application.
 */
void TvCtrlPointPrintLongHelp(void);

/*!
 * \briefPrint the list of valid command line commands to the user
 */
void TvCtrlPointPrintCommands(void);

/*!
 * \brief Function that receives commands from the user at the command prompt
 * during the lifetime of the device, and calls the appropriate
 * functions for those commands.
 */
void *TvCtrlPointCommandLoop(void *args);

/*!
 * \brief
 */
int TvCtrlPointProcessCommand(char *cmdline);

#ifdef __cplusplus
};
#endif

/*! @} Device Sample */

/*! @} UpnpSamples */

#endif /* UPNP_MYOUCTRL_H */
