#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void
write_file (const char *path, const char *value)
{
  FILE *f = fopen (path, "w");
  if (!f)
    {
      perror (path);
      return;
    }
  fwrite (value, 1, strlen (value), f);
  fclose (f);
}

int
main (int argc, char *argv[])
{
  if (argc != 2)
    {
      printf ("用法: %s on|off\n", argv[0]);
      return 1;
    }

  if (strcmp (argv[1], "off") == 0)
    {
      write_file ("/sys/class/leds/ACT/trigger", "none");
      write_file ("/sys/class/leds/ACT/brightness", "0");
      write_file ("/sys/class/leds/PWR/trigger", "none");
      write_file ("/sys/class/leds/PWR/brightness", "0");
      printf ("指示灯已关闭\n");
    }
  else if (strcmp (argv[1], "on") == 0)
    {
      write_file ("/sys/class/leds/ACT/trigger", "mmc0");
      write_file ("/sys/class/leds/PWR/trigger", "default-on");
      printf ("指示灯已恢复\n");
    }
  else
    {
      printf ("参数无效，用法: %s on|off\n", argv[0]);
      return 1;
    }

  return 0;

}
