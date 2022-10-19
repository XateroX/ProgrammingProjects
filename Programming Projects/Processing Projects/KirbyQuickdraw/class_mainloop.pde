class mainloop
{
    int mode;
    // Mode = 0 - build up
    // Mode = 1 - normal timing fight


    //mode 0 variables
    running_mode_0   = false;
    timer_mode_0     = 0;
    timer_max_mode_0 = 180;

    //mode 1 variables
    running_mode_1      = false;
    timer_mode_1        = 0;
    timer_target        = -1;
    display_mark_mode_1 = false;

    mainloop()
    {
        mode = 0;
        running_mode_0 = true;
    }

    public void loop()
    {
        if (mode == 0)
        {
            mode_buildup();
        }
        if (mode == 1)
        {
            mode_timingfight();
        }
    }

    public void mode_buildup()
    {
        if (timer_mode_0 >= timer_max_mode_0)
        {
            running_mode_0 = false;
        }
        timer_mode_0+=1;
    }

    public void mode_timingfight()
    {
        if (timer_mode_1 >= timer_target)
        {
            display_mark_mode_1 = true;
        }
        timer_mode_1 += 1
    }
}