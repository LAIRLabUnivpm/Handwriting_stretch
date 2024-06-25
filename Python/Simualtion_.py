###### ----- ######

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt
import string

###### ROBOT ######

import stretch_body.robot
from stretch_body.hello_utils import *
import time

###### -IK- ######

import ikpy.urdf.utils
import pathlib
import stretch_body.hello_utils as hu
from IPython import display
import ipywidgets as widgets

import urdfpy

import ikpy.chain

###### ----- ######

###### ----- ######

# Setup the Python API
robot = stretch_body.robot.Robot()
if not robot.startup():
    print("Failed to open connection to the robot")

# Ensure robot is homed
if not robot.is_calibrated():
    robot.home()



########################### ------URDF------ ###########################

urdf_path = "stretch_virtual_x_base.urdf"

tree = ikpy.urdf.utils.get_urdf_tree(urdf_path, "base_link")[0]
display.display_png(tree)


mask = [False, True, False, True, False, True, True, True, True, True, False, True , True, False, False]

chain = ikpy.chain.Chain.from_urdf_file(urdf_path, active_links_mask=mask)
chain
chain.links
########################### ----------------- ###########################

###########################    Funzioni IK    ###########################

###########################    IK - OFFLINE   ###########################

def get_current_configuration(k, q_input):

    def bound_range(name, value):
        names = [l.name for l in chain.links]
        index = names.index(name)
        bounds = chain.links[index].bounds
        return min(max(value, bounds[0]), bounds[1])
    
    if k == 0:
        q_base = 0.0
        q_lift = bound_range('joint_lift', robot.lift.status['pos'])
        q_arml = bound_range('joint_arm_l0', robot.arm.status['pos'] / 4.0)
        q_yaw = bound_range('joint_wrist_yaw', robot.end_of_arm.status['wrist_yaw']['pos'])
        q_pitch = bound_range('joint_wrist_pitch', robot.end_of_arm.status['wrist_pitch']['pos'])
        q_roll = bound_range('joint_wrist_roll', robot.end_of_arm.status['wrist_roll']['pos'])

        q_lift = round(q_lift, 3)
        q_arml = round(q_arml, 3)
        q_yaw = round(q_yaw, 3)
        q_pitch = round(q_pitch, 3)
        q_roll = round(q_roll, 3)
    else:
        q_base = q_input[1]
        q_lift = q_input[3]
        q_arml = q_input[5]
        q_yaw = q_input[9]
        q_pitch = q_input[11]
        q_roll = q_input[12]
        
    return [0.0, q_base, 0.0, q_lift, 0.0, q_arml, q_arml, q_arml, q_arml, q_yaw, 0.0, q_pitch, q_roll, 0.0, 0.0]

########################### ----------------- ###########################

def move_to_configuration(q):

    q_base = q[1]
    q_lift = q[3]
    q_arm = q[5] + q[6] + q[7] + q[8]
    q_yaw = q[9]
    q_pitch = q[11]
    q_roll = q[12]

    q_lift = round(q_lift, 3)
    q_arm = round(q_arm, 3)
    q_yaw = round(q_yaw, 3)
    q_pitch = round(q_pitch, 3)
    q_roll = round(q_roll, 3)
    

    # robot.base.translate_by(q_base)
    # robot.lift.move_to(q_lift)
    # robot.arm.move_to(q_arm)
    # robot.end_of_arm.move_to('wrist_yaw', q_yaw)
    # robot.end_of_arm.move_to('wrist_pitch', q_pitch)
    # robot.end_of_arm.move_to('wrist_roll', q_roll)

    robot.push_command()
    
########################### ----------------- ###########################

alfabeto = list(string.ascii_lowercase)
off_set =  -0.20
x_off_ste = 0.2363

for lett in alfabeto:

    robot.stow()

    # Percorso del file di testo
    file_path = 'alfabeto/'+lett+'.txt'

    ppp = "offline/"

    out_trajectories = ppp + "stretch_trajectories_/output_"+lett+".txt"
    out_error = ppp + "stretch_displacement_ERROR/error_"+lett+".txt"
    out_join_variables_off = ppp + "join_variable_offline/"+lett+".txt"

    # Inizializza una lista per memorizzare le coordinate
    coordinates = []

    # Leggi il file di testo e aggiungi le coordinate alla lista
    with open(file_path, 'r') as file:
        for line in file:
            # Dividi la riga in base agli spazi e converti le stringhe in float
            point = [float(x) for x in line.split()]
            # Aggiungi le coordinate alla lista
            coordinates.append(point)

    coordinates_2 = []
    out__ = []
    k = 0
    enter_var = 0
    verification = []
    joint_variables = []

    print("--------------------------------")
    print(file_path)
    print(out_trajectories)
    print(out_error)
    print("--------------------------------")

    tempo_i = time.time()
    tempo = []

    for i in coordinates:
        if lett == 'i':
            target_point = [x_offtaini+i[2], off_set - (i[0]/100), i[1]]
        else:
            target_point = [x_off_ste+i[2], off_set - i[0], i[1]]

        target_orientation = ikpy.utils.geometry.rpy_matrix(0.0, 0.0, 0)

        ########################################## 
        q_init = get_current_configuration(k, q_input=enter_var)

        q_soln = chain.inverse_kinematics(target_point, target_orientation, orientation_mode='all', initial_position=q_init)
        if q_soln[1] < 0.01:
            q_soln[1]=0
        joint_variables.append(q_soln)

        coordinates_2.append(chain.forward_kinematics(q_soln)[:3, 3])
        
        out__.append(np.linalg.norm(chain.forward_kinematics(q_soln)[:3, 3] - target_point))
        enter_var = q_soln

        #move_to_configuration(q=q_soln)

        if k == 0:
            k += 1

 ########################################## 
    # Scrivi la matrice nel file di testo
    with open(out_trajectories, 'w') as file:

        ########################################## OFFLINE
        for riga in coordinates_2:
            # Converti ogni elemento della riga in una stringa e uniscili con uno spazio
            riga_da_scrivere = ' '.join(map(str, riga))
            # Scrivi la riga nel file di testo
            file.write(riga_da_scrivere + '\n')

    with open(out_join_variables_off, 'w') as file:
        ########################################## OFFLINE
        for riga in joint_variables:
            # Converti ogni elemento della riga in una stringa e uniscili con uno spazio
            riga_da_scrivere = ' '.join(map(str, riga))
            # Scrivi la riga nel file di testo
            file.write(riga_da_scrivere + '\n')
    
    with open(out_error, 'w') as file:
        for riga in out__:
            # Scrivi la riga nel file di testo
            file.write(str(riga) + '\n')

    # Definisci le coordinate y e z per il primo plot
    ################ 
    coordinate = coordinates_2

    coor = coordinates

    # print(coor[0])
    # print(coordinate[0])

    x = [c[0] for c in coordinate]
    y = [c[1] for c in coordinate]
    z = [c[2] for c in coordinate]

    x2 = [0.23-c[2] for c in coor]
    y2 = [-0.2-c[0] for c in coor]
    z2 = [c[1] for c in coor]

    #print(f'{x2[0]}, {y2[0]}, {z2[0]}')
    
    fig = plt.figure()
    ax = fig.add_subplot(211, projection='3d')

    ax.scatter(x, y, z,  label='I by robot')
    ax.scatter(x2, y2, z2, s=10, label='REF')

    # Etichette degli assi
    ax.set_xlabel('Y')
    ax.set_ylabel('Z')
    ax.set_zlabel('X')

    ax.legend()

    # Definisci i valori per il secondo plot
    valori = out__
    join_variables_error = [ele[1] for ele in joint_variables]

    ax2d = fig.add_subplot(212)

    # Crea il secondo grafico
    ax2d.plot(valori, label="errore")
    ax2d.plot(join_variables_error, label='join_variables_error')
    ax2d.set_xlabel('X')
    ax2d.set_ylabel('Y')
    ax2d.legend()

    # Mostra entrambi i grafici
    plt.show()