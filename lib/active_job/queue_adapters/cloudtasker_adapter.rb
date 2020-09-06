# frozen_string_literal: true

# ActiveJob docs: http://guides.rubyonrails.org/active_job_basics.html
# Example adapters ref: https://github.com/rails/rails/tree/master/activejob/lib/active_job/queue_adapters

module ActiveJob
  module QueueAdapters
    # == Cloudtasker adapter for Active Job
    #
    # To use Cloudtasker set the queue_adapter config to +:cloudtasker+.
    #
    #   Rails.application.config.active_job.queue_adapter = :cloudtasker
    class CloudtaskerAdapter
      def enqueue(job)
        build_worker(job).schedule
      end

      def enqueue_at(job, precise_timestamp) #:nodoc:
        build_worker(job).schedule time_at: Time.at(precise_timestamp)
      end

      private

      def build_worker(job)
        job_serialization = job.serialize

        Worker.new job_queue: job_serialization['queue_name'],
                   job_args: [job_serialization],
                   job_id: job_serialization['job_id']
      end
    end
  end
end