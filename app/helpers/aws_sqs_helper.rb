require 'aws-sdk'

module AwsSqsHelper

	def send_msg_to_queue(message)
		Rails.logger.info(" #{Time.now} Ide video: " + message)
		Rails.logger.info(" #{Time.now} url sqs: " + ENV['AWS_SQS_ORIGINAL_VIDEOS'])
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.send_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], message_body: message)
	end

	def obtain_message_from_queue
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.receive_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], max_number_of_messages: 1)
		return resp.messages
	end

	def delete_message_from_queue(receipt_handle)
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.delete_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], receipt_handle: receipt_handle)
	end	

end