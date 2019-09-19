try:
    import tkinter as tk  # for python 3
except:
    import Tkinter as tk  # for python 2

import pygubu, asyncio
from sshtunnel import open_tunnel
from time import sleep

END_SERVER = False
STARTED = False

class Application:
    def __init__(self, master):

        #1: Create a builder
        self.builder = builder = pygubu.Builder()

        #2: Load an ui file
        builder.add_from_file('gui.ui')

        #3: Create the widget using a master as parent
        self.mainwindow = builder.get_object('MainWidget', master)

        # Connect method callbacks
        builder.connect_callbacks(self)

        self.builder.get_object("AdvancedSettings").parent = self.mainwindow
        self.builder.get_object("AdvancedSettings").bind('<<DialogClose>>', self.closeSettings)
    
    # Define callbacks
    def openSettings(self):
        self.builder.get_object("AdvancedSettings").run()

    def closeSettings(self, dialog):
        dialog.close()

    def startProxy(self):
        global STARTED
        SERVER = self.builder.get_object("InputServer").get()
        PORT = int(self.builder.get_object("InputPort").get())
        print(PORT)
        USER = self.builder.get_object("InputUser").get()
        PASSWD = self.builder.get_object("InputPassword").get()
        engage(SERVER, PORT, USER, PASSWD)
        STARTED = True

def engage(SERVER, PORT, USER, PASSWD):
    with open_tunnel(
        (SERVER, PORT),
        ssh_username=USER,
        ssh_password=PASSWD,
        remote_bind_address=("127.0.0.1", 8080)
    ) as server:
        print(server.local_bind_port)
        while not END_SERVER:
            sleep(1)

if __name__ == '__main__':
    root = tk.Tk()
    app = Application(root)
    root.mainloop()