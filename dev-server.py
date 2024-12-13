#!/usr/bin/env python3
import http.server
import socketserver
import os
import webbrowser
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time
import logging

# Configure logging
logging.basicConfig(level=logging.INFO,
                   format='%(asctime)s - %(message)s',
                   datefmt='%Y-%m-%d %H:%M:%S')

# Configuration
PORT = 8000
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class AutoReloadHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith(('.html', '.css', '.js')):
            logging.info(f"File changed: {event.src_path}")

class DevServer:
    def __init__(self):
        self.server = None
        self.observer = None

    def start(self):
        # Change to the directory containing your web files
        os.chdir(DIRECTORY)

        # Set up the server
        handler = http.server.SimpleHTTPRequestHandler
        self.server = socketserver.TCPServer(("", PORT), handler)

        # Set up file watching
        event_handler = AutoReloadHandler()
        self.observer = Observer()
        self.observer.schedule(event_handler, path=DIRECTORY, recursive=True)
        self.observer.start()

        # Open browser
        webbrowser.open(f'http://localhost:{PORT}')

        logging.info(f"Serving at http://localhost:{PORT}")
        logging.info("Press Ctrl+C to stop the server")

        try:
            self.server.serve_forever()
        except KeyboardInterrupt:
            self.stop()

    def stop(self):
        if self.server:
            self.server.shutdown()
            self.server.server_close()
        if self.observer:
            self.observer.stop()
            self.observer.join()
        logging.info("\nServer stopped")

if __name__ == "__main__":
    server = DevServer()
    server.start()
