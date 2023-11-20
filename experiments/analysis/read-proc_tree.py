import sys
import traceback
import time

now = int(time.monotonic_ns() / 1000000)

class Run:
    def __init__(self, name, time, num, 
                 exited, time_exited, signaled, time_signaled, othered, time_othered,
                 signaled_11, signaled_14, signaled_27, signaled_other) -> None:
        self.name = name
        self.time = time
        self.num  = num
        self.exited   = exited
        self.time_exited = time_exited

        self.signaled = signaled
        self.time_signaled = time_signaled
        self.signaled_11 = signaled_11
        self.signaled_14 = signaled_14
        self.signaled_27 = signaled_27
        self.signaled_other = signaled_other

        self.othered  = othered
        self.time_othered = time_othered

    

class ProcTree:
    def __init__(self, f_proc_tree) -> None:
        self.f_proc_tree = f_proc_tree
        self.tottime, self.totnum, self.run = self._getRun(f_proc_tree)
        
    def _getRun(self, f_proc_tree, skip = 0):
        tottime = 0
        totnum  = 0

        initial_time = None
        with open(f_proc_tree, encoding='utf-8', errors='replace') as f:
            run = []
            name = None
            time = None
            finaltime = None
            finalFlag = True
            num = 0
            skipped = 0

            num_exited = 0
            time_exited = 0
            num_signaled = 0
            time_signaled = 0
            num_signaled_11 = 0
            num_signaled_14 = 0
            num_signaled_27 = 0
            num_signaled_other = 0
            num_othered = 0
            time_othered = 0
            
            for l in f:
                finalFlag = False
                if l.startswith('--'):
                    newtime = int(l.split('--')[1].strip())
                    newname = '--'.join(l.split('--')[2:]).strip()
                    num = 0
                    if initial_time is None:
                        initial_time = newtime
                    time = newtime
                    name = newname

                    num_exited = 0
                    time_exited = 0
                    num_signaled = 0
                    time_signaled = 0
                    num_signaled_11 = 0
                    num_signaled_14 = 0
                    num_signaled_27 = 0
                    num_signaled_other = 0
                    num_othered = 0
                    time_othered = 0
                elif l.startswith('++'):
                    newtime = int(l.split('++')[1].split('--')[0].strip())
                    newname = '--'.join(l.split('--')[1:]).strip()
                    if name != newname:
                        print(name)
                        print(newname)
                    assert name == newname
                    if skipped >= skip:
                        totnum += num
                        tottime += newtime - time
                        run.append(Run(name, (newtime - time) / 1000, num, 
                                       num_exited,   time_exited   / 1000000000, 
                                       num_signaled, time_signaled / 1000000000, 
                                       num_othered,  time_othered  / 1000000000, 
                                       num_signaled_11, num_signaled_14, num_signaled_27, num_signaled_other))
                    else:
                        skipped += 1
                    finaltime = int(l.split('++')[1].split('--')[0].strip())
                    finalFlag = True
                elif l[0] in '0123456789':
                    num += 1
                    tmp_l = l.split("):")[1].split('/')
                    tmp_time = int(tmp_l[0].strip()) 
                    l = l.split("/")
                    assert len(l) == 1 or len(l) == 2 and f"{l}"
                    if len(l) == 1:
                        num_othered += 1
                        time_othered += tmp_time
                    elif l[1].startswith('r'):
                        num_exited += 1
                        time_exited += tmp_time
                    elif l[1].startswith('s'):
                        num_signaled += 1
                        time_signaled += tmp_time
                        tmp = int(l[1].split('s')[1].strip())
                        if tmp == 11:
                            num_signaled_11 += 1
                        elif tmp == 14:
                            num_signaled_14 += 1
                        elif tmp == 27:
                            num_signaled_27 += 1
                        else:
                            num_signaled_other += 1

                    else:
                        print(l)
                        exit(-1)
                    
                else:
                    assert False & "unkown line"
            
            
      
            return tottime/1000, totnum, run

    def __str__(self) -> str:
        ret = "Process tree: " + self.f_proc_tree + "\n"
        ret += "       time"
        ret += "        num"
        ret += "     exited"
        ret += "   signaled(11|14|27|ot) "
        ret += "    othered"
        ret += "   time_exited"
        ret += "   time_signaled(11|14|27|ot) "
        ret += "   time_othered"
        ret += '\n'
        for run in self.run:
            if isinstance(run, Run):
                ret += f"{run.time:>10.2f} {run.num:>10d} "
                ret += f"{run.exited:>10d} "
                ret += f"{run.signaled:>10d}"
                ret += f" ({run.signaled_11:>2d}|{run.signaled_14:>2d}|{run.signaled_27:>2d}|{run.signaled_other:>2d}) "
                ret += f"{run.othered:>10d} "
                ret += f"{run.time_exited:>10.2f} "
                ret += f"{run.time_signaled:>10.2f} "
                ret += f"{run.time_othered:>10.2f} "
                ret += '\n'
        ret += '\n'
        ret += 'tottime:\t{:>10.2f}\ntotnum: \t{:>10d}'.format(self.tottime, self.totnum)
        return ret

try:
    f_proc_tree = sys.argv[1]
    print(ProcTree(f_proc_tree))
except Exception as e:
    traceback.print_exc(file=sys.stdout)