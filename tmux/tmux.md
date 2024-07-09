# TMUX

Normally, when connecting to machines through SSH, you are creating a terminal session which is attached to to your SSH session. This means that whenever you close the terminal (or SSH connection) the programs started in that terminal will stop running. This is not ideal for cases where programs may need to run for a long time (e.g., training a neural network).

**Tmux** is an application that allows you to create detached terminal sessions. In practice, this allows you to run commands in the background, independently of your SSH connection.

## Common commands

### Key sequences
In tmux many actions require pressing a sequence of keys. For ease of reading, we will specify here how to interpret the sequences written in the following.

#### **_Press together_**
When referring to a series of keys to be pressed together, we will write: 
```
key1+key2
```
This sequence means that you should hold `key1`, and then press `key2` while holding `key1`.

#### **_Press in sequence_**
Differently, when indicating series of keys to press in sequence (not together), we will separate them with a comma `,`:
```
key1, key2
```
This means that you should press `key1`, let go, then press `key2`.

#### **_Final example_**
As a final example the following sequence
```
key1+key2, key3
```
Means that the user should press `key2` while holding `key1`, let go both of them, and then press `key3`

This will be a common thing in tmux, where the first keys in the sequence will often be the "option sequence", which by default is `ctrl+b`.

### Create a tmux session
To create a new tmux session, run the following command, replacing `<session_name>` with the desired session name.
```
tmux new -s <session_name>
```
You will automatically attach to the new session.

### Detach from a tmux session
While attached to (inside of) a tmux session, you can detach from it and keep it running in the background.
After having pressed the option sequence (do NOT hold it) press the `d` key.
The following examples uses the default option sequence `ctrl+b`.
```
ctrl+b, d
```

### Kill a tmux session
When attached to a tmux session, you can kill it (stopping the program running inside) by running the following sequence
```
ctrl+b, x
```
and confirming the prompt by pressing `y`.

If you want to kill a session you are not attached to, run the following command from the terminal
```
tmux kill-session -t <session_name>
```
replacing `<session_name>` with the appropriate session name.

### List all the tmux sessions
To see a list of tmux sessions run the following command in the terminal
```
tmux ls
```

### Enable mouse-wheel scrolling
By default, tmux does not allow to scroll the terminal with your mouse-wheel. To enable the current tmux session, first open the command terminal by pressing the following sequence
```
ctrl+b, :
```
then enter the following command
```
set -g mouse on
```

### Disable mouse-wheel scrolling
Similarly, to disable mouse scrolling:
```
ctrl+b, :
```
then enter the following command
```
set -g mouse off
```

## Usage guidelines
- Tmux should be used for all those programs that require a long time to run, in order to allow us to detach the session without fear of losing progress.
One example is training a network: you should create a tmux session and start the training from command line inside the tmux session.
Another similar use case is when copying a large amount of files.

- Try to keep the session names inherent to what you are running inside, so it's easier to remember what to look for.

- It's a good practice to kill all the sessions that are not running or not needed.

- You don't need to use tmux when debugging, or when running simple scripts.