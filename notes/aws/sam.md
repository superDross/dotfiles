Install a remote debugger to your directory containing the application.

```
pip install rempote_pdb pdbpp -t app/
```

To create a breakpoint place the below snippet in your code:

```
from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 6900).set_trace()
```

Build and invoke your lambda.

```
sam local invoke -d 6900 -e event.json
```

Connect to the debugger.

```
telnet 0.0.0.0 6900
```
