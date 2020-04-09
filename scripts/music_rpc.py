#! /bin/env python

from dataclasses import dataclass
from hashlib import md5
from subprocess import run
from time import sleep, time

from pypresence import Presence


song = ''
presence = Presence("676663717483642882")
presence.connect()


@dataclass
class Song:
    album: str
    title: str
    artist: str
    length: float

    def __post_init__(self) -> None:
        """My assets are named after their MD5 hashes."""
        self.asset = md5(
            self.album.encode()
        ).hexdigest()

    @staticmethod
    def latest() -> 'Song':
        """Get the latest song info."""
        return Song(
            playerctl('metadata', 'album'),
            playerctl('metadata', 'title'),
            playerctl('metadata', 'artist'),
            int(
                playerctl('metadata', 'mpris:length')
            ) / 1000000
        )


def playerctl(*arguments: str) -> str:
    """Run a playerctl command."""
    return run(
        ('playerctl', *arguments),
        capture_output=True
    ).stdout.decode().strip()


print('[?] Listening for song updates...')

while True:
    if song != (song := Song.latest()):
        print(f'[!] Updating RPC with song "{song.title}"')
        start = time()
        presence.update(
            large_image=song.asset,
            state=song.artist,
            large_text=song.album,
            details=song.title,
            start=start,
            end=start + song.length,
        )
    sleep(1)
