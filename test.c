#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/firmware.h>
#include <linux/platform_device.h>
#include <linux/delay.h>

static struct platform_device *pdev;

static int __init test_init(void)
{
	int ret;
	const struct firmware *config;

	pdev = platform_device_register_simple("fake-dev", 0, NULL, 0);
	if (IS_ERR(pdev))
		return PTR_ERR(pdev);

	/* You can just do ls / > /lib/firmware/fake.bin to fake the fw */
	ret = request_firmware(&config, "fake.bin", &pdev->dev);
	if (ret < 0) {
		dev_set_uevent_suppress(&pdev->dev, true);
		platform_device_unregister(pdev);
		return ret;
	}

	ssleep(3);

	release_firmware(config);

	return 0;
}

static void __exit test_exit(void)
{
	dev_set_uevent_suppress(&pdev->dev, true);
	platform_device_unregister(pdev);
}

module_init(test_init)
module_exit(test_exit)
MODULE_LICENSE("GPL");
