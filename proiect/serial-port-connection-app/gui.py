import serial
from Tkinter import *
import tkMessageBox

from serial import PARITY_ODD, EIGHTBITS, STOPBITS_ONE

global start_window
global fpga


def start_window():
    global start_window
    start_window = Tk()
    start_window.title("Serial Port Terminal Emulator by Stoian Iulia Tia")
    start_window.geometry("600x400")

    # connect button
    Button(text="CONNECT", width="30", height="2", command=connect).pack(pady=185)

    start_window.mainloop()


def connect():
    global fpga
    try:
        fpga = serial.Serial(port="com4", baudrate=9600, timeout=0, bytesize=EIGHTBITS, parity=PARITY_ODD,
                             stopbits=STOPBITS_ONE)
        tkMessageBox.showinfo("Success!", "Serial connection at port COM4 established.")
        print("Serial connection at port COM4 established.")

    except:
        tkMessageBox.showinfo("Error!", "The connection could not be established.")
        print("The connection could not be established.")
        return

    terminal_window = Toplevel(start_window)
    terminal_window.title("Terminal for Received Data through RX communication Line")
    terminal_window.geometry("600x400")

    def receive():
        data = fpga.read(size=2)
        output_textbox.insert(END, data[0:1] + " ")


    # receive button
    Button(terminal_window, text="RECEIVE DATA", width="30", height="2", command=receive).pack()

    output_textbox = Text(terminal_window, width=600, height=370, wrap=WORD)
    output_textbox.pack()


start_window()
