/** @file
 *	@brief MAVLink comm protocol generated from common.xml
 *	@see http://qgroundcontrol.org/mavlink/
 */
#ifndef COMMON_H
#define COMMON_H

#define MAVLINK_ENABLED_COMMON

// ENUM DEFINITIONS


/** @brief Micro air vehicle / autopilot classes. This identifies the individual model. */
#ifndef HAVE_ENUM_MAV_AUTOPILOT
#define HAVE_ENUM_MAV_AUTOPILOT
enum MAV_AUTOPILOT
{
	MAV_AUTOPILOT_GENERIC=0, /* Generic autopilot, full support for everything | */
	MAV_AUTOPILOT_PIXHAWK=1, /* PIXHAWK autopilot, http://pixhawk.ethz.ch | */
	MAV_AUTOPILOT_SLUGS=2, /* SLUGS autopilot, http://slugsuav.soe.ucsc.edu | */
	MAV_AUTOPILOT_ARDUPILOTMEGA=3, /* ArduPilotMega / ArduCopter, http://diydrones.com | */
	MAV_AUTOPILOT_OPENPILOT=4, /* OpenPilot, http://openpilot.org | */
	MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY=5, /* Generic autopilot only supporting simple waypoints | */
	MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY=6, /* Generic autopilot supporting waypoints and other simple navigation commands | */
	MAV_AUTOPILOT_GENERIC_MISSION_FULL=7, /* Generic autopilot supporting the full mission command set | */
	MAV_AUTOPILOT_INVALID=8, /* No valid autopilot, e.g. a GCS or other MAVLink component | */
	MAV_AUTOPILOT_PPZ=9, /* PPZ UAV - http://nongnu.org/paparazzi | */
	MAV_AUTOPILOT_UDB=10, /* UAV Dev Board | */
	MAV_AUTOPILOT_FP=11, /* FlexiPilot | */
	MAV_AUTOPILOT_PX4=12, /* PX4 Autopilot - http://pixhawk.ethz.ch/px4/ | */
	MAV_AUTOPILOT_ENUM_END=13, /*  | */
};
#endif

/** @brief  */
#ifndef HAVE_ENUM_MAV_TYPE
#define HAVE_ENUM_MAV_TYPE
enum MAV_TYPE
{
	MAV_TYPE_GENERIC=0, /* Generic micro air vehicle. | */
	MAV_TYPE_FIXED_WING=1, /* Fixed wing aircraft. | */
	MAV_TYPE_QUADROTOR=2, /* Quadrotor | */
	MAV_TYPE_COAXIAL=3, /* Coaxial helicopter | */
	MAV_TYPE_HELICOPTER=4, /* Normal helicopter with tail rotor. | */
	MAV_TYPE_ANTENNA_TRACKER=5, /* Ground installation | */
	MAV_TYPE_GCS=6, /* Operator control unit / ground control station | */
	MAV_TYPE_AIRSHIP=7, /* Airship, controlled | */
	MAV_TYPE_FREE_BALLOON=8, /* Free balloon, uncontrolled | */
	MAV_TYPE_ROCKET=9, /* Rocket | */
	MAV_TYPE_GROUND_ROVER=10, /* Ground rover | */
	MAV_TYPE_SURFACE_BOAT=11, /* Surface vessel, boat, ship | */
	MAV_TYPE_SUBMARINE=12, /* Submarine | */
	MAV_TYPE_HEXAROTOR=13, /* Hexarotor | */
	MAV_TYPE_OCTOROTOR=14, /* Octorotor | */
	MAV_TYPE_TRICOPTER=15, /* Octorotor | */
	MAV_TYPE_FLAPPING_WING=16, /* Flapping wing | */
	MAV_TYPE_KITE=17, /* Flapping wing | */
	MAV_TYPE_ENUM_END=18, /*  | */
};
#endif

/** @brief These flags encode the MAV mode. */
#ifndef HAVE_ENUM_MAV_MODE_FLAG
#define HAVE_ENUM_MAV_MODE_FLAG
enum MAV_MODE_FLAG
{
	MAV_MODE_FLAG_CUSTOM_MODE_ENABLED=1, /* 0b00000001 Reserved for future use. | */
	MAV_MODE_FLAG_TEST_ENABLED=2, /* 0b00000010 system has a test mode enabled. This flag is intended for temporary system tests and should not be used for stable implementations. | */
	MAV_MODE_FLAG_AUTO_ENABLED=4, /* 0b00000100 autonomous mode enabled, system finds its own goal positions. Guided flag can be set or not, depends on the actual implementation. | */
	MAV_MODE_FLAG_GUIDED_ENABLED=8, /* 0b00001000 guided mode enabled, system flies MISSIONs / mission items. | */
	MAV_MODE_FLAG_STABILIZE_ENABLED=16, /* 0b00010000 system stabilizes electronically its attitude (and optionally position). It needs however further control inputs to move around. | */
	MAV_MODE_FLAG_HIL_ENABLED=32, /* 0b00100000 hardware in the loop simulation. All motors / actuators are blocked, but internal software is full operational. | */
	MAV_MODE_FLAG_MANUAL_INPUT_ENABLED=64, /* 0b01000000 remote control input is enabled. | */
	MAV_MODE_FLAG_SAFETY_ARMED=128, /* 0b10000000 MAV safety set to armed. Motors are enabled / running / can start. Ready to fly. | */
	MAV_MODE_FLAG_ENUM_END=129, /*  | */
};
#endif

/** @brief These values encode the bit positions of the decode position. These values can be used to read the value of a flag bit by combining the base_mode variable with AND with the flag position value. The result will be either 0 or 1, depending on if the flag is set or not. */
#ifndef HAVE_ENUM_MAV_MODE_FLAG_DECODE_POSITION
#define HAVE_ENUM_MAV_MODE_FLAG_DECODE_POSITION
enum MAV_MODE_FLAG_DECODE_POSITION
{
	MAV_MODE_FLAG_DECODE_POSITION_CUSTOM_MODE=1, /* Eighth bit: 00000001 | */
	MAV_MODE_FLAG_DECODE_POSITION_TEST=2, /* Seventh bit: 00000010 | */
	MAV_MODE_FLAG_DECODE_POSITION_AUTO=4, /* Sixt bit:   00000100 | */
	MAV_MODE_FLAG_DECODE_POSITION_GUIDED=8, /* Fifth bit:  00001000 | */
	MAV_MODE_FLAG_DECODE_POSITION_STABILIZE=16, /* Fourth bit: 00010000 | */
	MAV_MODE_FLAG_DECODE_POSITION_HIL=32, /* Third bit:  00100000 | */
	MAV_MODE_FLAG_DECODE_POSITION_MANUAL=64, /* Second bit: 01000000 | */
	MAV_MODE_FLAG_DECODE_POSITION_SAFETY=128, /* First bit:  10000000 | */
	MAV_MODE_FLAG_DECODE_POSITION_ENUM_END=129, /*  | */
};
#endif

/** @brief Override command, pauses current mission execution and moves immediately to a position */
#ifndef HAVE_ENUM_MAV_GOTO
#define HAVE_ENUM_MAV_GOTO
enum MAV_GOTO
{
	MAV_GOTO_DO_HOLD=0, /* Hold at the current position. | */
	MAV_GOTO_DO_CONTINUE=1, /* Continue with the next item in mission execution. | */
	MAV_GOTO_HOLD_AT_CURRENT_POSITION=2, /* Hold at the current position of the system | */
	MAV_GOTO_HOLD_AT_SPECIFIED_POSITION=3, /* Hold at the position specified in the parameters of the DO_HOLD action | */
	MAV_GOTO_ENUM_END=4, /*  | */
};
#endif

/** @brief These defines are predefined OR-combined mode flags. There is no need to use values from this enum, but it
               simplifies the use of the mode flags. Note that manual input is enabled in all modes as a safety override. */
#ifndef HAVE_ENUM_MAV_MODE
#define HAVE_ENUM_MAV_MODE
enum MAV_MODE
{
	MAV_MODE_PREFLIGHT=0, /* System is not ready to fly, booting, calibrating, etc. No flag is set. | */
	MAV_MODE_MANUAL_DISARMED=64, /* System is allowed to be active, under manual (RC) control, no stabilization | */
	MAV_MODE_TEST_DISARMED=66, /* UNDEFINED mode. This solely depends on the autopilot - use with caution, intended for developers only. | */
	MAV_MODE_STABILIZE_DISARMED=80, /* System is allowed to be active, under assisted RC control. | */
	MAV_MODE_GUIDED_DISARMED=88, /* System is allowed to be active, under autonomous control, manual setpoint | */
	MAV_MODE_AUTO_DISARMED=92, /* System is allowed to be active, under autonomous control and navigation (the trajectory is decided onboard and not pre-programmed by MISSIONs) | */
	MAV_MODE_MANUAL_ARMED=192, /* System is allowed to be active, under manual (RC) control, no stabilization | */
	MAV_MODE_TEST_ARMED=194, /* UNDEFINED mode. This solely depends on the autopilot - use with caution, intended for developers only. | */
	MAV_MODE_STABILIZE_ARMED=208, /* System is allowed to be active, under assisted RC control. | */
	MAV_MODE_GUIDED_ARMED=216, /* System is allowed to be active, under autonomous control, manual setpoint | */
	MAV_MODE_AUTO_ARMED=220, /* System is allowed to be active, under autonomous control and navigation (the trajectory is decided onboard and not pre-programmed by MISSIONs) | */
	MAV_MODE_ENUM_END=221, /*  | */
};
#endif

/** @brief  */
#ifndef HAVE_ENUM_MAV_STATE
#define HAVE_ENUM_MAV_STATE
enum MAV_STATE
{
	MAV_STATE_UNINIT=0, /* Uninitialized system, state is unknown. | */
	MAV_STATE_BOOT=1, /* System is booting up. | */
	MAV_STATE_CALIBRATING=2, /* System is calibrating and not flight-ready. | */
	MAV_STATE_STANDBY=3, /* System is grounded and on standby. It can be launched any time. | */
	MAV_STATE_ACTIVE=4, /* System is active and might be already airborne. Motors are engaged. | */
	MAV_STATE_CRITICAL=5, /* System is in a non-normal flight mode. It can however still navigate. | */
	MAV_STATE_EMERGENCY=6, /* System is in a non-normal flight mode. It lost control over parts or over the whole airframe. It is in mayday and going down. | */
	MAV_STATE_POWEROFF=7, /* System just initialized its power-down sequence, will shut down now. | */
	MAV_STATE_ENUM_END=8, /*  | */
};
#endif

/** @brief  */
#ifndef HAVE_ENUM_MAV_COMPONENT
#define HAVE_ENUM_MAV_COMPONENT
enum MAV_COMPONENT
{
	MAV_COMP_ID_ALL=0, /*  | */
	MAV_COMP_ID_CAMERA=100, /*  | */
	MAV_COMP_ID_SERVO1=140, /*  | */
	MAV_COMP_ID_SERVO2=141, /*  | */
	MAV_COMP_ID_SERVO3=142, /*  | */
	MAV_COMP_ID_SERVO4=143, /*  | */
	MAV_COMP_ID_SERVO5=144, /*  | */
	MAV_COMP_ID_SERVO6=145, /*  | */
	MAV_COMP_ID_SERVO7=146, /*  | */
	MAV_COMP_ID_SERVO8=147, /*  | */
	MAV_COMP_ID_SERVO9=148, /*  | */
	MAV_COMP_ID_SERVO10=149, /*  | */
	MAV_COMP_ID_SERVO11=150, /*  | */
	MAV_COMP_ID_SERVO12=151, /*  | */
	MAV_COMP_ID_SERVO13=152, /*  | */
	MAV_COMP_ID_SERVO14=153, /*  | */
	MAV_COMP_ID_MAPPER=180, /*  | */
	MAV_COMP_ID_MISSIONPLANNER=190, /*  | */
	MAV_COMP_ID_PATHPLANNER=195, /*  | */
	MAV_COMP_ID_IMU=200, /*  | */
	MAV_COMP_ID_IMU_2=201, /*  | */
	MAV_COMP_ID_IMU_3=202, /*  | */
	MAV_COMP_ID_GPS=220, /*  | */
	MAV_COMP_ID_UDP_BRIDGE=240, /*  | */
	MAV_COMP_ID_UART_BRIDGE=241, /*  | */
	MAV_COMP_ID_SYSTEM_CONTROL=250, /*  | */
	MAV_COMPONENT_ENUM_END=251, /*  | */
};
#endif

/** @brief  */
#ifndef HAVE_ENUM_MAV_FRAME
#define HAVE_ENUM_MAV_FRAME
enum MAV_FRAME
{
	MAV_FRAME_GLOBAL=0, /* Global coordinate frame, WGS84 coordinate system. First value / x: latitude, second value / y: longitude, third value / z: positive altitude over mean sea level (MSL) | */
	MAV_FRAME_LOCAL_NED=1, /* Local coordinate frame, Z-up (x: north, y: east, z: down). | */
	MAV_FRAME_MISSION=2, /* NOT a coordinate frame, indicates a mission command. | */
	MAV_FRAME_GLOBAL_RELATIVE_ALT=3, /* Global coordinate frame, WGS84 coordinate system, relative altitude over ground with respect to the home position. First value / x: latitude, second value / y: longitude, third value / z: positive altitude with 0 being at the altitude of the home location. | */
	MAV_FRAME_LOCAL_ENU=4, /* Local coordinate frame, Z-down (x: east, y: north, z: up) | */
	MAV_FRAME_ENUM_END=5, /*  | */
};
#endif

/** @brief  */
#ifndef HAVE_ENUM_MAVLINK_DATA_STREAM_TYPE
#define HAVE_ENUM_MAVLINK_DATA_STREAM_TYPE
enum MAVLINK_DATA_STREAM_TYPE
{
	MAVLINK_DATA_STREAM_IMG_JPEG=1, /*  | */
	MAVLINK_DATA_STREAM_IMG_BMP=2, /*  | */
	MAVLINK_DATA_STREAM_IMG_RAW8U=3, /*  | */
	MAVLINK_DATA_STREAM_IMG_RAW32U=4, /*  | */
	MAVLINK_DATA_STREAM_IMG_PGM=5, /*  | */
	MAVLINK_DATA_STREAM_IMG_PNG=6, /*  | */
	MAVLINK_DATA_STREAM_TYPE_ENUM_END=7, /*  | */
};
#endif

/** @brief Data stream IDs. A data stream is not a fixed set of messages, but rather a
     recommendation to the autopilot software. Individual autopilots may or may not obey
     the recommended messages. */
#ifndef HAVE_ENUM_MAV_DATA_STREAM
#define HAVE_ENUM_MAV_DATA_STREAM
enum MAV_DATA_STREAM
{
	MAV_DATA_STREAM_ALL=0, /* Enable all data streams | */
	MAV_DATA_STREAM_RAW_SENSORS=1, /* Enable IMU_RAW, GPS_RAW, GPS_STATUS packets. | */
	MAV_DATA_STREAM_EXTENDED_STATUS=2, /* Enable GPS_STATUS, CONTROL_STATUS, AUX_STATUS | */
	MAV_DATA_STREAM_RC_CHANNELS=3, /* Enable RC_CHANNELS_SCALED, RC_CHANNELS_RAW, SERVO_OUTPUT_RAW | */
	MAV_DATA_STREAM_RAW_CONTROLLER=4, /* Enable ATTITUDE_CONTROLLER_OUTPUT, POSITION_CONTROLLER_OUTPUT, NAV_CONTROLLER_OUTPUT. | */
	MAV_DATA_STREAM_POSITION=6, /* Enable LOCAL_POSITION, GLOBAL_POSITION/GLOBAL_POSITION_INT messages. | */
	MAV_DATA_STREAM_EXTRA1=10, /* Dependent on the autopilot | */
	MAV_DATA_STREAM_EXTRA2=11, /* Dependent on the autopilot | */
	MAV_DATA_STREAM_EXTRA3=12, /* Dependent on the autopilot | */
	MAV_DATA_STREAM_ENUM_END=13, /*  | */
};
#endif

/** @brief  The ROI (region of interest) for the vehicle. This can be
                be used by the vehicle for camera/vehicle attitude alignment (see
                MAV_CMD_NAV_ROI). */
#ifndef HAVE_ENUM_MAV_ROI
#define HAVE_ENUM_MAV_ROI
enum MAV_ROI
{
	MAV_ROI_NONE=0, /* No region of interest. | */
	MAV_ROI_WPNEXT=1, /* Point toward next MISSION. | */
	MAV_ROI_WPINDEX=2, /* Point toward given MISSION. | */
	MAV_ROI_LOCATION=3, /* Point toward fixed location. | */
	MAV_ROI_TARGET=4, /* Point toward of given id. | */
	MAV_ROI_ENUM_END=5, /*  | */
};
#endif

/** @brief ACK / NACK / ERROR values as a result of MAV_CMDs and for mission item transmission. */
#ifndef HAVE_ENUM_MAV_CMD_ACK
#define HAVE_ENUM_MAV_CMD_ACK
enum MAV_CMD_ACK
{
	MAV_CMD_ACK_OK=1, /* Command / mission item is ok. | */
	MAV_CMD_ACK_ERR_FAIL=2, /* Generic error message if none of the other reasons fails or if no detailed error reporting is implemented. | */
	MAV_CMD_ACK_ERR_ACCESS_DENIED=3, /* The system is refusing to accept this command from this source / communication partner. | */
	MAV_CMD_ACK_ERR_NOT_SUPPORTED=4, /* Command or mission item is not supported, other commands would be accepted. | */
	MAV_CMD_ACK_ERR_COORDINATE_FRAME_NOT_SUPPORTED=5, /* The coordinate frame of this command / mission item is not supported. | */
	MAV_CMD_ACK_ERR_COORDINATES_OUT_OF_RANGE=6, /* The coordinate frame of this command is ok, but he coordinate values exceed the safety limits of this system. This is a generic error, please use the more specific error messages below if possible. | */
	MAV_CMD_ACK_ERR_X_LAT_OUT_OF_RANGE=7, /* The X or latitude value is out of range. | */
	MAV_CMD_ACK_ERR_Y_LON_OUT_OF_RANGE=8, /* The Y or longitude value is out of range. | */
	MAV_CMD_ACK_ERR_Z_ALT_OUT_OF_RANGE=9, /* The Z or altitude value is out of range. | */
	MAV_CMD_ACK_ENUM_END=10, /*  | */
};
#endif

/** @brief Specifies the datatype of a MAVLink parameter. */
#ifndef HAVE_ENUM_MAV_PARAM_TYPE
#define HAVE_ENUM_MAV_PARAM_TYPE
enum MAV_PARAM_TYPE
{
	MAV_PARAM_TYPE_UINT8=1, /* 8-bit unsigned integer | */
	MAV_PARAM_TYPE_INT8=2, /* 8-bit signed integer | */
	MAV_PARAM_TYPE_UINT16=3, /* 16-bit unsigned integer | */
	MAV_PARAM_TYPE_INT16=4, /* 16-bit signed integer | */
	MAV_PARAM_TYPE_UINT32=5, /* 32-bit unsigned integer | */
	MAV_PARAM_TYPE_INT32=6, /* 32-bit signed integer | */
	MAV_PARAM_TYPE_UINT64=7, /* 64-bit unsigned integer | */
	MAV_PARAM_TYPE_INT64=8, /* 64-bit signed integer | */
	MAV_PARAM_TYPE_REAL32=9, /* 32-bit floating-point | */
	MAV_PARAM_TYPE_REAL64=10, /* 64-bit floating-point | */
	MAV_PARAM_TYPE_ENUM_END=11, /*  | */
};
#endif

/** @brief result from a mavlink command */
#ifndef HAVE_ENUM_MAV_RESULT
#define HAVE_ENUM_MAV_RESULT
enum MAV_RESULT
{
	MAV_RESULT_ACCEPTED=0, /* Command ACCEPTED and EXECUTED | */
	MAV_RESULT_TEMPORARILY_REJECTED=1, /* Command TEMPORARY REJECTED/DENIED | */
	MAV_RESULT_DENIED=2, /* Command PERMANENTLY DENIED | */
	MAV_RESULT_UNSUPPORTED=3, /* Command UNKNOWN/UNSUPPORTED | */
	MAV_RESULT_FAILED=4, /* Command executed, but failed | */
	MAV_RESULT_ENUM_END=5, /*  | */
};
#endif

/** @brief result in a mavlink mission ack */
#ifndef HAVE_ENUM_MAV_MISSION_RESULT
#define HAVE_ENUM_MAV_MISSION_RESULT
enum MAV_MISSION_RESULT
{
	MAV_MISSION_ACCEPTED=0, /* mission accepted OK | */
	MAV_MISSION_ERROR=1, /* generic error / not accepting mission commands at all right now | */
	MAV_MISSION_UNSUPPORTED_FRAME=2, /* coordinate frame is not supported | */
	MAV_MISSION_UNSUPPORTED=3, /* command is not supported | */
	MAV_MISSION_NO_SPACE=4, /* mission item exceeds storage space | */
	MAV_MISSION_INVALID=5, /* one of the parameters has an invalid value | */
	MAV_MISSION_INVALID_PARAM1=6, /* param1 has an invalid value | */
	MAV_MISSION_INVALID_PARAM2=7, /* param2 has an invalid value | */
	MAV_MISSION_INVALID_PARAM3=8, /* param3 has an invalid value | */
	MAV_MISSION_INVALID_PARAM4=9, /* param4 has an invalid value | */
	MAV_MISSION_INVALID_PARAM5_X=10, /* x/param5 has an invalid value | */
	MAV_MISSION_INVALID_PARAM6_Y=11, /* y/param6 has an invalid value | */
	MAV_MISSION_INVALID_PARAM7=12, /* param7 has an invalid value | */
	MAV_MISSION_INVALID_SEQUENCE=13, /* received waypoint out of sequence | */
	MAV_MISSION_DENIED=14, /* not accepting any mission commands from this communication partner | */
	MAV_MISSION_RESULT_ENUM_END=15, /*  | */
};
#endif

/** @brief Indicates the severity level, generally used for status messages to indicate their relative urgency. Based on RFC-5424 using expanded definitions at: http://www.kiwisyslog.com/kb/info:-syslog-message-levels/. */
#ifndef HAVE_ENUM_MAV_SEVERITY
#define HAVE_ENUM_MAV_SEVERITY
enum MAV_SEVERITY
{
	MAV_SEVERITY_EMERGENCY=0, /* System is unusable. This is a "panic" condition. | */
	MAV_SEVERITY_ALERT=1, /* Action should be taken immediately. Indicates error in non-critical systems. | */
	MAV_SEVERITY_CRITICAL=2, /* Action must be taken immediately. Indicates failure in a primary system. | */
	MAV_SEVERITY_ERROR=3, /* Indicates an error in secondary/redundant systems. | */
	MAV_SEVERITY_WARNING=4, /* Indicates about a possible future error if this is not resolved within a given timeframe. Example would be a low battery warning. | */
	MAV_SEVERITY_NOTICE=5, /* An unusual event has occured, though not an error condition. This should be investigated for the root cause. | */
	MAV_SEVERITY_INFO=6, /* Normal operational messages. Useful for logging. No action is required for these messages. | */
	MAV_SEVERITY_DEBUG=7, /* Useful non-operational messages that can assist in debugging. These should not occur during normal operation. | */
	MAV_SEVERITY_ENUM_END=8, /*  | */
};
#endif



// MAVLINK VERSION

#ifndef MAVLINK_VERSION
#define MAVLINK_VERSION 3
#endif

#if (MAVLINK_VERSION == 0)
#undef MAVLINK_VERSION
#define MAVLINK_VERSION 3
#endif

// MESSAGE DEFINITIONS
/*
#include "./mavlink_msg_heartbeat.h"
#include "./mavlink_msg_sys_status.h"
#include "./mavlink_msg_system_time.h"
#include "./mavlink_msg_ping.h"
#include "./mavlink_msg_change_operator_control.h"
#include "./mavlink_msg_change_operator_control_ack.h"
#include "./mavlink_msg_auth_key.h"
#include "./mavlink_msg_set_mode.h"
#include "./mavlink_msg_param_request_read.h"
#include "./mavlink_msg_param_request_list.h"
#include "./mavlink_msg_param_value.h"
#include "./mavlink_msg_param_set.h"
#include "./mavlink_msg_gps_raw_int.h"
#include "./mavlink_msg_gps_status.h"
#include "./mavlink_msg_scaled_imu.h"
#include "./mavlink_msg_raw_imu.h"
#include "./mavlink_msg_raw_pressure.h"
#include "./mavlink_msg_scaled_pressure.h"
#include "./mavlink_msg_attitude.h"
#include "./mavlink_msg_attitude_quaternion.h"
#include "./mavlink_msg_local_position_ned.h"
#include "./mavlink_msg_global_position_int.h"
#include "./mavlink_msg_rc_channels_scaled.h"
#include "./mavlink_msg_rc_channels_raw.h"
#include "./mavlink_msg_servo_output_raw.h"
#include "./mavlink_msg_mission_request_partial_list.h"
#include "./mavlink_msg_mission_write_partial_list.h"
#include "./mavlink_msg_mission_item.h"
#include "./mavlink_msg_mission_request.h"
#include "./mavlink_msg_mission_set_current.h"
#include "./mavlink_msg_mission_current.h"
#include "./mavlink_msg_mission_request_list.h"
#include "./mavlink_msg_mission_count.h"
#include "./mavlink_msg_mission_clear_all.h"
#include "./mavlink_msg_mission_item_reached.h"
#include "./mavlink_msg_mission_ack.h"
#include "./mavlink_msg_set_gps_global_origin.h"
#include "./mavlink_msg_gps_global_origin.h"
#include "./mavlink_msg_set_local_position_setpoint.h"
#include "./mavlink_msg_local_position_setpoint.h"
#include "./mavlink_msg_global_position_setpoint_int.h"
#include "./mavlink_msg_set_global_position_setpoint_int.h"
#include "./mavlink_msg_safety_set_allowed_area.h"
#include "./mavlink_msg_safety_allowed_area.h"
#include "./mavlink_msg_set_roll_pitch_yaw_thrust.h"
#include "./mavlink_msg_set_roll_pitch_yaw_speed_thrust.h"
#include "./mavlink_msg_roll_pitch_yaw_thrust_setpoint.h"
#include "./mavlink_msg_roll_pitch_yaw_speed_thrust_setpoint.h"
#include "./mavlink_msg_set_quad_motors_setpoint.h"
#include "./mavlink_msg_set_quad_swarm_roll_pitch_yaw_thrust.h"
#include "./mavlink_msg_nav_controller_output.h"
#include "./mavlink_msg_set_quad_swarm_led_roll_pitch_yaw_thrust.h"
#include "./mavlink_msg_state_correction.h"
#include "./mavlink_msg_request_data_stream.h"
#include "./mavlink_msg_data_stream.h"
#include "./mavlink_msg_manual_control.h"
#include "./mavlink_msg_rc_channels_override.h"
#include "./mavlink_msg_vfr_hud.h"
#include "./mavlink_msg_command_long.h"
#include "./mavlink_msg_command_ack.h"
#include "./mavlink_msg_roll_pitch_yaw_rates_thrust_setpoint.h"
#include "./mavlink_msg_manual_setpoint.h"
#include "./mavlink_msg_local_position_ned_system_global_offset.h"
#include "./mavlink_msg_hil_state.h"
#include "./mavlink_msg_hil_controls.h"
#include "./mavlink_msg_hil_rc_inputs_raw.h"
#include "./mavlink_msg_optical_flow.h"
#include "./mavlink_msg_global_vision_position_estimate.h"
#include "./mavlink_msg_vision_position_estimate.h"
#include "./mavlink_msg_vision_speed_estimate.h"
#include "./mavlink_msg_vicon_position_estimate.h"
#include "./mavlink_msg_highres_imu.h"
#include "./mavlink_msg_file_transfer_start.h"
#include "./mavlink_msg_file_transfer_dir_list.h"
#include "./mavlink_msg_file_transfer_res.h"
#include "./mavlink_msg_battery_status.h"
#include "./mavlink_msg_setpoint_8dof.h"
#include "./mavlink_msg_setpoint_6dof.h"
#include "./mavlink_msg_memory_vect.h"
#include "./mavlink_msg_debug_vect.h"
#include "./mavlink_msg_named_value_float.h"
#include "./mavlink_msg_named_value_int.h"
#include "./mavlink_msg_statustext.h"
#include "./mavlink_msg_debug.h"
*/
#endif // COMMON_H
