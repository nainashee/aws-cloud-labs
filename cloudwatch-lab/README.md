# CloudWatch Monitoring Lab

## What I Built
A CloudWatch alarm that monitors EC2 CPU utilization and triggers an SNS notification when usage exceeds 50% for 5 minutes.

## Architecture
```
EC2 Instance
    |
CloudWatch Metric (CPUUtilization)
    |
CloudWatch Alarm (threshold: > 50% for 5 minutes)
    |
SNS Topic (Default_CloudWatch_Alarms_Topic)
    |
Email / SMS Notification
```

## What I Did
- Navigated to CloudWatch → Metrics → EC2 → Per-Instance Metrics
- Located CPUUtilization metric for my EC2 instance
- Created an alarm: CPUUtilization > 50% for 1 datapoint within 5 minutes
- Created an SNS topic and added email subscription for notifications
- Stress tested the instance using `yes > /dev/null &` to spike CPU to ~100%
- Observed CPU spike on the CloudWatch graph crossing the 50% threshold
- Watched alarm lifecycle: Insufficient data → In alarm → OK

## Break/Fix Exercise
**Issue:** Alarm showed "Insufficient data" for over 12 minutes despite CPU spiking
**Root cause:** Alarm was pointed at the wrong instance ID (old terminated instance)
**Fix:** Edited the alarm and updated the InstanceId to the correct running instance
**Lesson:** Always verify the alarm is targeting the correct resource — wrong instance ID is a common cause of "Insufficient data"

## Key Concepts Learned
- CloudWatch has three monitoring layers: basic (free, 5-min), detailed (1-min, paid), and CloudWatch Agent (OS-level metrics and logs)
- Basic monitoring sends CPU metrics automatically — no agent needed for CPUUtilization
- A 5-minute evaluation period prevents false alarms from short CPU spikes (noise reduction)
- Alarm states: **Insufficient data** (not enough points yet), **In alarm** (threshold breached), **OK** (below threshold)
- SNS is the delivery layer — CloudWatch detects, SNS notifies
- S3 buckets are private by default (least privilege applied at storage level)
- Presigned URLs provide temporary, expiring access without making objects public

## Mistakes Made and Fixed
- SNS email subscription kept auto-unsubscribing due to email security bot clicking the unsubscribe link — resolved by resubscribing and switching to SMS
- Alarm pointed at wrong instance ID — caused persistent "Insufficient data" state until corrected
