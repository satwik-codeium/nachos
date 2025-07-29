package nachos.threads;

import nachos.machine.*;

/**
 * An implementation of condition variables that disables interrupt()s for
 * synchronization.
 *
 * <p>
 * You must implement this.
 *
 * @see	nachos.threads.Condition2
 */
public class Condition2 {
    private Lock conditionLock;
    private LinkedList<KThread> waitQueue;
    /**
     * Allocate a new condition variable.
     *
     * @param	conditionLock	the lock associated with this condition
     *				variable. The current thread must hold this
     *				lock whenever it uses <tt>sleep()</tt>,
     *				<tt>wake()</tt>, or <tt>wakeAll()</tt>.
     */
    public Condition2(Lock conditionLock) {
        this.conditionLock = conditionLock;
        this.waitQueue = new LinkedList<KThread>();
    }

    /**
     * Atomically release the associated lock and go to sleep on this condition
     * variable until another thread wakes it using <tt>wake()</tt>. The
     * current thread must hold the associated lock. The thread will
     * automatically reacquire the lock before <tt>sleep()</tt> returns.
     */
    public void sleep() {
        Lib.assertTrue(conditionLock.isHeldByCurrentThread());

        boolean intStatus = Machine.interrupt().disable();
        conditionLock.release();

        KThread thread = KThread.currentThread();
        waitQueue.add(thread);
        thread.sleep();

        Machine.interrupt().restore(intStatus);
    }

    /**
     * Wake up at most one thread sleeping on this condition variable. The
     * current thread must hold the associated lock.
     */
    public void wake() {
        Lib.assertTrue(conditionLock.isHeldByCurrentThread());

        boolean intStatus = Machine.interrupt().disable();
        if (!waitQueue.isEmpty()) {
            KThread thread = waitQueue.removeFirst();
            thread.ready();
        }
        Machine.interrupt().restore(intStatus);
    }

    /**
     * Wake up all threads sleeping on this condition variable. The current
     * thread must hold the associated lock.
     */
    public void wakeAll() {
        Lib.assertTrue(conditionLock.isHeldByCurrentThread());

        boolean intStatus = Machine.interrupt().disable();
        while (!waitQueue.isEmpty()) {
            KThread thread = waitQueue.removeFirst();
            thread.ready();
        }
        Machine.interrupt().restore(intStatus);
    }

    private Lock conditionLock;
    private LinkedList<KThread> waitQueue = new LinkedList<KThread>();
}


public class Condition2Test {
    public static void selfTest() {
        final Lock lock = new Lock();
        final Condition2 condition = new Condition2(lock);

        KThread consumer = new KThread(new Runnable() {
            public void run() {
                lock.acquire();
                while (true) {
                    condition.sleep();
                    System.out.println("Consumed");
                }
            }
        });

        KThread producer = new KThread(new Runnable() {
            public void run() {
                lock.acquire();
                while (true) {
                    System.out.println("Produced");
                    condition.wake();
                    lock.release();
                    ThreadedKernel.alarm.waitUntil(1000);
                    lock.acquire();
                }
            }
        });

        consumer.fork();
        producer.fork();
    }
}

